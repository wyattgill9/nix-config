# Btrfs migration — `zen`

Execution plan: both NVMe drives become one btrfs pool, `nixpool` (data `single`, metadata
`raid1`), with a 4 GB tmpfs root via [impermanence](https://github.com/nix-community/impermanence).

The migration runs **in place**. The pool is built on the idle drive, the live system is copied
onto it, and the old drive joins the pool only after the new system has proven itself. There is
no external staging, no 500 GiB Steam re-download, and the old system stays bootable until Phase 2.

Rationale: `system-overhaul.md` on branch `docs/system-overhaul`. Where the two disagree, this
file wins (§8).

## 1. Drives

Kernel names are **not stable** across boots: when the design doc was written, `nvme0n1` was
`…549C`; on 2026-10-06 it is `…76466`. Every command below uses `/dev/disk/by-id` or partlabels.

| `/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_…` | Now | After | disko |
|---|---|---|---|
| `50026B7686B7549C` | idle: 1G vfat + 930.5G ext4 | `p1` ESP `/boot` 1G, `p2` pool (created first) | `main` |
| `50026B7686B76466` | **live**: 512M ESP + ext4 `/`, 710G used | `p1` pool (added in Phase 2) | `extra` |

The spec's `nvme0n1p2 + nvme1n1p1` (design-doc naming) means `…549C-part2 + …76466-part1`.

Payload ≈ 660 GiB: `/home` 633 (Steam 506, `~/.cache` excluded), system closure 22,
`/var/lib` + `/var/log` 4. It fits on `…549C` alone.

```
nixpool  btrfs  -d single -m raid1  compress=zstd:1,noatime  ≈1.82 TiB
  /nix → /nix        /persist → /persist        /home → /home
  /log → /var/log    /games → /games (NOCOW)    /snapshots → /.snapshots
/      tmpfs 4G, wiped every boot
/boot  vfat 1G on …549C-part1
```

## 2. Config

Tested against `master` @ `00f9fd4`: the full system evaluates and every assertion passes. All
subvolumes mount from `/dev/disk/by-partlabel/disk-main-pool`. `/`, `/nix`, `/persist`,
`/var/log` and the `/var/lib/nixos` bind mount happen in initrd. `disk-extra-pool` appears only in
disko's format script, never in `fileSystems`, so one config serves both phases.

> [!WARNING]
> Until Phase 2 is done, never run the disko CLI with this config: it declares the live drive a
> pool member and would wipe it. Never `nixos-rebuild switch`/`boot` the old system with it either.

**`flake.nix`**, add to `inputs`:

```nix
impermanence = {
  url = "github:nix-community/impermanence";
  inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.follows = "home-manager";
};
```

**`hosts/zen/hardware.nix`**: delete `fileSystems."/"` and `fileSystems."/boot"`. disko generates both now.

**`hosts/zen/disko.nix`**, replace:

```nix
_: let
  opts = ["compress=zstd:1" "noatime"];
in {
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = ["size=4G" "mode=755"];
    };

    disk = {
      # disko formats disks alphabetically and mkfs.btrfs needs every member
      # present, so the disk that creates the pool must sort last: extra < main.
      extra = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B7686B76466";
        content = {
          type = "gpt";
          partitions.pool.size = "100%"; # no content: second member of main's pool
        };
      };

      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B7686B7549C";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["fmask=0077" "dmask=0077"];
              };
            };
            pool = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-L" "nixpool" "-d" "single" "-m" "raid1" "/dev/disk/by-partlabel/disk-extra-pool"];
                subvolumes = {
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = opts;
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = opts;
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = opts;
                  };
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = opts;
                  };
                  "/games" = {
                    mountpoint = "/games";
                    mountOptions = opts;
                  };
                  "/snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = opts;
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
}
```

**`modules/nixos/impermanence.nix`**, new (picked up by `importDir`):

```nix
{
  inputs,
  username,
  ...
}: {
  imports = [inputs.impermanence.nixosModules.impermanence];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos" # uid/gid map: lose it and /home ownership drifts
      "/var/lib/systemd"
      "/var/lib/tailscale"
      "/var/lib/NetworkManager"
      "/var/lib/bluetooth"
      "/var/lib/alsa"
      "/var/lib/fail2ban"
      "/var/lib/flatpak"
      "/var/lib/cups"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  # / is tmpfs, so /etc/shadow is rebuilt from these files on every boot.
  users.mutableUsers = false;
  users.users.${username}.hashedPasswordFile = "/persist/passwords/${username}";
  users.users.root.hashedPasswordFile = "/persist/passwords/root";

  # Steam patches multi-GB files in place; keep /games NOCOW.
  systemd.tmpfiles.rules = ["h /games - - - - +C"];

  services.btrfs.autoScrub.enable = true;

  zramSwap.enable = true;
}
```

The persist list covers every stateful service enabled in this config, cross-checked against
`/var/lib` on the live system.

## 3. Phase 0: prepare (non-destructive)

1. Confirm `…549C` holds nothing you want, and look in `/root`, which becomes tmpfs:
   ```sh
   sudo mkdir /tmp/old; sudo mount -o ro /dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B7686B7549C-part2 /tmp/old
   sudo ls -la /tmp/old /tmp/old/home /root; sudo umount /tmp/old
   ```
2. Insurance against operator error: push every repo in `~/Github` and `~/nx`. Copy `~/.ssh`,
   `~/.local/share/keyrings`, `~/.zen`, `~/.thunderbird` and `~/.local/share/Steam/steamapps/compatdata`
   (Proton saves) to a USB stick, about 7 GiB. Keep a NixOS installer USB on hand.
3. Record identity to compare after boot:
   `cat /etc/machine-id; ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub; id`
4. Apply §2 on a branch and build:
   ```sh
   cd ~/nx; git switch -c btrfs-migration
   # apply §2, then:
   nix flake lock; git add flake.nix flake.lock hosts modules; git commit -m "zen: btrfs pool + impermanence"
   nix build .#nixosConfigurations.zen.config.system.build.toplevel -o /tmp/zen-new
   ```

## 4. Phase 1: pool on `…549C`, install, boot

Nothing here writes to `…76466`. Quit Steam first. Run as root in bash: `sudo -i`, then
`nix shell nixpkgs#gptfdisk nixpkgs#btrfs-progs nixpkgs#efibootmgr`, then:

```sh
M=/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B7686B7549C
P=/dev/disk/by-partlabel/disk-main-pool
o=compress=zstd:1,noatime
```

**1. Partition and format.** Partlabels follow disko's `disk-<disk>-<partition>` scheme.

```sh
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS $M   # expect 1G vfat + 930.5G ext4, NO mountpoints
wipefs -a $M-part1 $M-part2
sgdisk --zap-all $M
sgdisk -n1:0:+1G -t1:EF00 -c1:disk-main-ESP -n2:0:0 -t2:8300 -c2:disk-main-pool $M
udevadm settle
mkfs.vfat -F 32 /dev/disk/by-partlabel/disk-main-ESP
mkfs.btrfs -L nixpool -d single -m dup $P  # one device for now; metadata becomes raid1 in Phase 2
```

**2. Subvolumes.** NOCOW is inherited when a file is created, so set it before the copy.

```sh
mkdir -p /mnt; mount $P /mnt
btrfs subvolume create /mnt/{nix,persist,home,log,games,snapshots}
chattr +C /mnt/games
umount /mnt
```

**3. Mount the target tree.**

```sh
mount -t tmpfs -o size=4G,mode=755 none /mnt
mkdir -p /mnt/{boot,nix,persist,home,var/log,games,.snapshots}
mount -o fmask=0077,dmask=0077 /dev/disk/by-partlabel/disk-main-ESP /mnt/boot
for s in nix persist home games; do mount -o $o,subvol=/$s $P /mnt/$s; done
mount -o $o,subvol=/log $P /mnt/var/log
mount -o $o,subvol=/snapshots $P /mnt/.snapshots
```

**4. Copy state.** The bulk pass runs now and takes 1–2 h. Run it again in step 7.

```sh
cat > /root/sync.sh <<'EOF'
set -e
r() { rsync -aHAX --numeric-ids --delete --info=progress2 "$@" || [ $? = 24 ]; }  # 24: file vanished mid-copy
r --exclude=/wyattgill/.cache/ --exclude=/wyattgill/.local/share/Steam/steamapps/ /home/ /mnt/home/
install -d -o wyattgill -g users /mnt/games/SteamLibrary
r --exclude=/libraryfolders.vdf /home/wyattgill/.local/share/Steam/steamapps/ /mnt/games/SteamLibrary/steamapps/
mkdir -p /mnt/persist/var/lib /mnt/persist/etc/ssh
r /var/lib/{nixos,systemd,tailscale,NetworkManager,bluetooth,alsa,fail2ban,flatpak,cups} /mnt/persist/var/lib/
r /var/log/ /mnt/var/log/
cp -a /etc/machine-id /mnt/persist/etc/
cp -a /etc/ssh/ssh_host_* /mnt/persist/etc/ssh/
EOF
bash /root/sync.sh
```

**5. Passwords.** Copy the current hashes so nothing changes.

```sh
mkdir -m 700 /mnt/persist/passwords
for u in wyattgill root; do getent shadow $u | cut -d: -f2 > /mnt/persist/passwords/$u; done
chmod 600 /mnt/persist/passwords/*; cut -c1-3 /mnt/persist/passwords/*   # $y$ or $6$; "!" = locked
```

If root is locked, a failed mount drops you into an emergency shell you can't enter. Set one
with `mkpasswd -m yescrypt > /mnt/persist/passwords/root`.

**6. Rollback entry, then install.** The new ESP goes first in the boot order.

```sh
efibootmgr -c -d /dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B7686B76466 -p 1 -L zen-ext4-old -l '\EFI\systemd\systemd-bootx64.efi'
nixos-install --root /mnt --system $(readlink -f /tmp/zen-new) --no-root-passwd --no-channel-copy
```

**7. Final sync, then reboot.** Log out of Hyprland, switch to a free TTY (Ctrl+Alt+F3), log in, then run:

```sh
sudo bash /root/sync.sh && sudo umount -R /mnt && sudo reboot
```

**8. Verify.** Log in with your usual password.

```sh
findmnt -no FSTYPE /                 # tmpfs
sudo btrfs filesystem usage /nix     # Data,single  Metadata,DUP
cat /etc/machine-id; ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub; id   # same as Phase 0
tailscale status; systemctl --failed; lsattr -d /games/SteamLibrary         # C flag set
```

In Steam, go to Settings → Storage → Add Drive and choose `/games/SteamLibrary`. Make it the
default library and cap downloads at ~30 MB/s. If a game still shows Install, click it: Steam
finds the files and verifies them instead of downloading. Reboot once more; anything lost was
undeclared state, so add it to §2. Then `git switch master; git merge btrfs-migration; git push`.

## 5. Phase 2: absorb `…76466` (after a day of normal use)

This destroys the rollback path. Run as root: `sudo -i`, then
`nix shell nixpkgs#gptfdisk nixpkgs#efibootmgr`, then:

```sh
E=/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B7686B76466
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS $E      # expect 512M vfat + ext4, NO mountpoints
wipefs -a $E-part1 $E-part2
sgdisk --zap-all $E
sgdisk -n1:0:0 -t1:8300 -c1:disk-extra-pool $E
udevadm settle
btrfs device add /dev/disk/by-partlabel/disk-extra-pool /nix  # any pool mount addresses the whole fs
btrfs balance start -mconvert=raid1 /nix                     # metadata + system → RAID1; data stays single
btrfs filesystem usage /nix   # Data,single  Metadata,RAID1  System,RAID1  2 devices  ≈1.82 TiB
```

Cap `/games` only after the balance, because qgroups slow balances. Full qgroups rescan existing
data; `--simple` would not count it.

```sh
btrfs quota enable /nix && btrfs quota rescan -W /nix
btrfs qgroup limit 1200G /games
btrfs qgroup show -rF /games   # rfer ≈ library size, max_rfer 1.17TiB
```

Remove dead boot entries: run `efibootmgr -v`, then `efibootmgr -b XXXX -B` for `zen-ext4-old` and
for any `Linux Boot Manager` whose GUID isn't the one from
`blkid -s PARTUUID -o value /dev/disk/by-partlabel/disk-main-ESP`.

No data balance is needed: new chunks land on the emptier drive by themselves. For an even split
right away, run `btrfs balance start -d --bg /nix` overnight (heavy IO).

## 6. Rollback

- **Before Phase 2:** pick `zen-ext4-old` in the firmware boot menu. `…76466` was never written,
  and Phase 1 can be redone at any time because it only touches `…549C`.
- **After Phase 2:** use systemd-boot's previous generations. There is no ext4 to go back to.
- **A drive dies later:** initrd waits for both members, so boot stops. From a live USB, mount
  with `-o degraded,ro` and copy out what survives. Metadata is mirrored; data is not.

## 7. Deliberately not carried over

`~/.cache` (23 GiB, regenerates) · all old generations (they mount the ext4 root) ·
`/etc/ly/save.txt` (ly forgets the last user) · NetworkManager's stale "Wired connection 1"
(`eno1-static` is declarative) · `/var/lib/{libvirt,qemu,swtpm-localca,lightdm,sddm}` (no
enabled service uses them) · `/var/db/sudo` (sudo shows its lecture once per boot).

## 8. Changes vs `system-overhaul.md`

- **In place instead of wipe-both-and-restore.** uids, machine-id, SSH host keys, Tailscale auth,
  passwords and Proton saves carry over unchanged. The doc's ~10 GB backup list missed `~/Github`
  (102 GiB), the Zen and Thunderbird profiles, and `compatdata`.
- **Disk roles are swapped.** The pool is created on `…549C` (`main`) and `…76466` joins later
  (`extra`). The doc's line that "`nvme0n1` holds an old install" is wrong on today's boot:
  `nvme0n1` is the live drive.
- **`/` is tmpfs**, so `btrfs quota enable /`, `btrfs filesystem usage /` and
  `autoScrub.fileSystems = [ "/" ]` all fail. Use any pool mount; scrub's default already picks one.
- **impermanence now has `nixpkgs` and `home-manager` inputs**, so the config adds `follows`.
  §6.4 (`/tmp` in RAM vs Nix builds) no longer applies: Nix 2.34 builds in `/nix/var/nix/builds`.
- **Dropped as redundant:** `neededForBoot` on `/var/log` and `boot.initrd.supportedFilesystems`
  (NixOS derives both), `autoScrub.interval` (monthly is the default), and the btrfs top-level
  `mountOptions` (unused without a top-level mountpoint).
