# System Overhaul — `zen`

Rearchitecture of the `zen` host: one btrfs pool across both NVMe drives, ephemeral
root via [impermanence](https://github.com/nix-community/impermanence).

Written 2026-10-06, from measurements taken on the live system. Not yet applied.

**Status:** design + runbook. Nothing in this document has been executed.

---

## Contents

1. [Why](#1-why) — the diagnosis that prompted this
2. [Requirements](#2-requirements)
3. [Rejected alternatives](#3-rejected-alternatives)
4. [Target architecture](#4-target-architecture)
5. [Config changes](#5-config-changes)
6. [Hazards that lock you out](#6-hazards-that-lock-you-out)
7. [Install runbook](#7-install-runbook)
8. [Post-install verification](#8-post-install-verification)
9. [Phase 2 — home impermanence](#9-phase-2--home-impermanence)
10. [Housekeeping](#10-housekeeping)

---

## 1. Why

Reported symptom: launching `claude` and opening new terminal windows took seconds,
and the browser was sluggish with three tabs open.

It was not CPU, not RAM, and not the shell.

```
/proc/pressure/io   full avg10=59.21  avg60=62.01  avg300=52.48
/proc/pressure/cpu  full avg10=0.00   avg60=0.00   avg300=0.00
/proc/pressure/mem  full avg10=0.03   avg60=0.03   avg300=0.00
```

IO pressure `full` means every task on the machine was blocked waiting for disk.
Sustained **52–62%**. CPU pressure was flat zero on a 24-thread 9900X, and 23 GiB
of 30 GiB RAM was available.

### Root cause

Steam (PID 3227) was installing **Wuthering Waves** and had written **85.44 GB and
read 42.62 GB in 20 minutes of uptime** — roughly 70 MB/s sustained.

Root filesystem was **87% full (121 GB free)** on a **Kingston SNV2S1000G (NV2)**:
a DRAM-less budget drive that borrows host memory and whose SLC write cache shrinks
as the drive fills. Push 85 GB through that and the cache is exhausted, so writes
land directly on TLC while garbage collection thrashes behind them.

Measured device latency:

| Test | Result | Healthy NVMe |
|---|---|---|
| 50 × 4K `fsync` under load | **15.91 s → 318 ms each** | < 1 ms |
| 64 × 64K direct write + fsync | 8.49 s / 16.91 s / 20.17 s | < 0.1 s |
| Same test after download eased | 0.04 s → 4 ms each | — |
| Cumulative writes since boot | 779,293 writes @ **18.66 ms avg** | 0.1–0.3 ms |
| Cumulative reads since boot | 553,308 reads @ 1.91 ms avg | 0.05–0.1 ms |

318 ms for a single 4K fsync. A 7200 RPM spinning disk does that in ~10 ms.

### Why that froze unrelated apps

ext4 with `data=ordered` uses **one global journal**. An `fsync` from any process
forces a journal commit that serializes every other writer on the filesystem.
Firefox/Zen is heavily fsync-dependent (`places.sqlite`, `cookies.sqlite`, favicons,
a session-store commit every 15 s), so Steam's write flood and the browser's small
SQLite commits queued behind each other. One page navigation did several commits ×
300 ms and hung for over a second. Tab count was irrelevant — memory pressure was zero.

App launches suffered the same way: starting `claude` or `ghostty` means thousands of
small cold reads out of `/nix/store` (20,483 paths, deep symlink chains).

### Ruled out

- **Shell startup.** fish starts in **30 ms** (bash: 270 ms). Not the cause.
- **TRIM.** `fstrim.timer` is enabled and working — 277.3 GiB trimmed 2026-09-28,
  210.7 GiB on 2026-10-05.
- **Thermals.** NVMe at 37/51 °C and 46/55 °C. No throttling.
- **PCIe link.** Both drives negotiated 16.0 GT/s ×4 (PCIe 4.0 ×4). Neither degraded.
- **Memory / swap.** 23 GiB available, zero memory pressure. (No swap configured at all,
  which is addressed below but was not the cause.)

### Contributing factors

- **The second drive was completely idle.** `nvme0n1` logged 158 reads and **zero
  writes** since boot. A whole 931 GB drive doing nothing while the other one drowned.
- **Steam was ~68% of the root filesystem**: 506 GB in `~/.local/share/Steam`, of which
  98 GB was shadercache (76 GB for Wuthering Waves alone).
- `systemd-tmpfiles-clean.service` burned **27.8 s** of a 30.6 s boot — itself a symptom.
- At diagnosis time `waycast-daemon.service` held **1136 tasks and 24.5 GB** in a single
  cgroup (Steam, Zen, everything launched from it), which defeats per-app IO and memory
  limits. *Resolved since:* waycast is disabled in favour of rofi as of `00f9fd4`.

---

## 2. Requirements

1. **One filesystem systemwide.** All 1.85 TB visible as a single pool, not two mounts.
2. **No RAID0.** Explicitly rejected.
3. **Impermanence.** `nix-community/impermanence`, ephemeral root, declared state.

---

## 3. Rejected alternatives

| Approach | All 2 TB? | Reinstall? | One drive dies → | Fixes the bug? |
|---|---|---|---|---|
| Separate `/games` mount | yes | no | lose that drive only | **yes** |
| mergerfs union | yes | no | lose that drive's files | partly |
| LVM linear | yes | yes | filesystem damaged | no |
| **RAID0 stripe** | yes | yes | **everything, both drives** | no |
| **btrfs `-d single` multi-device** ← chosen | yes | yes | lose that drive's chunks | **mostly** |

RAID0 was rejected on two grounds. It multiplies *bandwidth*, not *latency* — a single
4K fsync still lands on exactly one drive and waits a full device round-trip, and the
measured problem was 318 ms of latency. And annualized failure rate for consumer NVMe
runs 1–2%, so a two-drive stripe carries roughly **2–4% per year of total loss across
both drives** with no redundancy to recover from.

A separate `/games` mount on the second drive remains the technically strongest option
— it is the only one that gives *hard* IO isolation between games and the desktop. It
was set aside to satisfy requirement 1.

---

## 4. Target architecture

Btrfs is the only filesystem that pools both drives into one namespace *without* striping.

```
mkfs.btrfs -d single -m raid1 -L nixpool /dev/<b> /dev/<a>
           ───┬─────  ───┬────
              │          └─ metadata MIRRORED across both drives
              └─ data NOT striped: each chunk lives wholly on one drive
```

- `-d single` — a 5 GB `.pak` file sits entirely on one drive. One drive dies, you lose
  only the files whose chunks were on it. No RAID0 failure coupling.
- `-m raid1` — the filesystem tree is mirrored (metadata is ~1–2% of capacity). After a
  drive failure the pool still mounts `-o degraded` and you can *enumerate exactly what
  was lost* rather than facing an unmountable array.
- `df` reports **one 1.85 TB figure**.

> **Be explicit about `-d single`.** Multi-device `mkfs.btrfs` has historically defaulted
> data to **raid0** — precisely what requirement 2 rules out. Do not rely on the default.

### Layout

```
nvme0n1  KINGSTON_SNV2S1000G_50026B7686B7549C   (disko "a")
├─ p1   1G     vfat    /boot          ESP
└─ p2   930G   ─────┐  raw, adopted into pool
                    │
nvme1n1  KINGSTON_SNV2S1000G_50026B7686B76466  (disko "b")
└─ p1   931G   btrfs ◄┘  "nixpool"   1.85 TB, compress=zstd:1, noatime
       ├─ @nix        → /nix
       ├─ @persist    → /persist       declared system state
       ├─ @home       → /home
       ├─ @log        → /var/log
       ├─ @games      → /games         Steam library, NOCOW
       └─ @snapshots  → /.snapshots

/  = tmpfs 4G    ephemeral, wiped every boot
```

### Why this also fixes the original problem

1. **Fill drops 81% → 38%.** 703 GB in 1.85 TB. This was the actual cause of the 318 ms
   fsync — a DRAM-less NV2 with no SLC headroom. Solved by capacity alone.
2. **Per-subvolume tree-logs.** Btrfs commits fsync through a per-subvolume tree-log
   rather than ext4's single global journal, so Steam committing in `@games` no longer
   forces a stall on the browser in `@home`. This directly attacks the serialization
   mechanism identified in §1.
3. **zstd:1 compression** halves the bytes physically written to a drive whose weakness
   is bytes written. Free on an idle 24-thread CPU.
4. **The btrfs allocator prefers the device with the most free space**, so writes spread
   across both drives — some of RAID0's parallelism without the failure coupling.

### The cost of requirement 1

With one pool, **Steam filling the disk can take the system down with it** — no space
left for the nix store or logs. Two separate filesystems made that structurally
impossible. The mitigation is a kernel-enforced cap on the games subvolume:

```sh
btrfs quota enable /
btrfs qgroup limit 1.2T /games
```

Btrfs quotas carry a known performance cost on balance and scrub operations. The
alternative is discipline: keep the pool under ~70% and watch `btrfs filesystem usage /`.

---

## 5. Config changes

### `hosts/zen/disko.nix` (replace)

```nix
_: {
  disko.devices = {
    # Ephemeral root. Impermanence.
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "size=4G" "mode=755" ];
    };

    disk = {
      # Attribute names matter: disko formats alphabetically, and mkfs.btrfs needs
      # every member device present. The disk CREATING the pool must sort last, so "b".
      a = {
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
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };
            # No `content`: disko creates the partition and leaves it unformatted,
            # so mkfs.btrfs on disk b can adopt it as the pool's second device.
            pool = { size = "100%"; };
          };
        };
      };

      b = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B7686B76466";
        content = {
          type = "gpt";
          partitions = {
            pool = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L" "nixpool"
                  "-d" "single"   # data NOT striped
                  "-m" "raid1"    # metadata mirrored: survive a drive loss
                  "/dev/disk/by-partlabel/disk-a-pool"
                ];
                # btrfs mount options are FILESYSTEM-wide, not per-subvolume. Keep them
                # identical everywhere or the kernel silently ignores the mismatched
                # ones. /games gets NOCOW via chattr instead.
                mountOptions = [ "compress=zstd:1" "noatime" ];
                subvolumes = {
                  "/nix"       = { mountpoint = "/nix";        mountOptions = [ "compress=zstd:1" "noatime" ]; };
                  "/persist"   = { mountpoint = "/persist";    mountOptions = [ "compress=zstd:1" "noatime" ]; };
                  "/home"      = { mountpoint = "/home";       mountOptions = [ "compress=zstd:1" "noatime" ]; };
                  "/log"       = { mountpoint = "/var/log";    mountOptions = [ "compress=zstd:1" "noatime" ]; };
                  "/games"     = { mountpoint = "/games";      mountOptions = [ "compress=zstd:1" "noatime" ]; };
                  "/snapshots" = { mountpoint = "/.snapshots"; mountOptions = [ "compress=zstd:1" "noatime" ]; };
                };
              };
            };
          };
        };
      };
    };
  };

  # Impermanence bind-mounts and journald run before normal mounts.
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}
```

Two changes from the current file:

- **Drop `enableConfig = false`** so disko owns `fileSystems`.
- **Device paths are `by-id`.** The current `/dev/nvme1n1` is a coin flip across boots
  with two identical drives — kernel enumeration order is not stable.

Verify the partlabel after partitioning before trusting it: `ls /dev/disk/by-partlabel/`.
Disko's convention is `disk-<diskName>-<partitionName>`.

### `hosts/zen/hardware.nix` (edit)

Delete `fileSystems."/"`, `fileSystems."/boot"` and `swapDevices` — disko generates those
now, and two sources of truth for mounts is how you end up unbootable. Keep the kernel
modules and `hostPlatform`. Drop the "Do not modify this file!" header, since it is being
modified.

Add btrfs to initrd; `/nix` must mount before the system starts:

```nix
boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
boot.initrd.supportedFilesystems = [ "btrfs" ];
```

### `modules/nixos/impermanence.nix` (new)

`modules/nixos/default.nix` does `importDir ./.`, so this is auto-imported.

```nix
{ inputs, ... }: {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"            # uid/gid map. Without this your users get
                                  # renumbered and every file's owner breaks.
      "/var/lib/systemd"          # timers, random-seed, coredumps
      "/var/lib/tailscale"        # services.tailscale — else you re-auth every boot
      "/var/lib/NetworkManager"   # leases/state; profiles are declarative already
      "/var/lib/bluetooth"        # pairings; powerOnBoot = true
      "/var/lib/alsa"             # hardware.alsa.enablePersistence = true
      "/var/lib/fail2ban"         # ban database
      "/var/lib/flatpak"          # services.flatpak.enable
      "/var/lib/cups"             # printing.enable
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  # Steam patches multi-GB .pak files in place. Copy-on-write turns that into
  # fragmentation hell, so mark /games NOCOW while it is still empty.
  systemd.tmpfiles.rules = [ "h /games - - - - +C" ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # No swap currently configured. zram is compressed swap in RAM — zero disk
  # writes, which is the right trade on a drive whose weakness is bytes written.
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
}
```

Every entry in that list was derived from an enabled service in this config, not from a
generic template. `openssh` is enabled in `modules/nixos/hardening.nix`; `tailscale` in
`modules/nixos/networking.nix`; `alsa.enablePersistence` in `modules/nixos/audio.nix`.

### `flake.nix` (add input)

Impermanence is a pure module set with no `nixpkgs` input to follow:

```nix
impermanence.url = "github:nix-community/impermanence";
```

---

## 6. Hazards that lock you out

In order of severity. These are the ones that catch everybody.

### 6.1 Your password — read this before rebooting

Root is tmpfs, so `/etc/shadow` is regenerated from config on every boot. **No password
is declared in this config.** After the first reboot you will not be able to log in.

```nix
users.mutableUsers = false;
users.users.wyattgill.hashedPasswordFile = "/persist/passwords/wyattgill";
users.users.root.hashedPasswordFile = "/persist/passwords/root";
```

Those files must exist *before* `nixos-install` (see runbook step 7).

### 6.2 `/var/lib/nixos`

Miss it and uid/gid allocations shuffle on rebuild, leaving every file in `/home` owned
by the wrong user.

### 6.3 SSH host keys

`openssh` is enabled. Without persisting the host keys, the machine's identity changes
every boot and every client refuses to connect on a changed-fingerprint error.

### 6.4 `/tmp` is now RAM

tmpfs root means `/tmp` lives in RAM. Large local nix builds can OOM a 30 GB box. Bind
`/tmp` to a subvolume if you build much outside the binary cache.

### 6.5 `/etc/machine-id`

Needed very early by systemd. Impermanence bind-mounts it, which works, but it is the
first thing to check on first boot if journald behaves strangely.

---

## 7. Install runbook

> **Destroys both drives.** `nvme0n1` currently holds what appears to be an old NixOS
> install (FAT32 ESP + ext4 root, unmounted, absent from this config). Confirm there is
> nothing wanted on it first:
> `sudo mount -o ro /dev/nvme0n1p2 /mnt/check && ls -la /mnt/check`

### 1. Back up — about 10 GB

Of 703 GB used, 506 GB is Steam (re-downloadable), 23 GB is `.cache` (regenerates), and
`/nix/store` rebuilds from the flake. Irreplaceable state is roughly:

```sh
rsync -aAXv --info=progress2 \
  ~/.ssh ~/.config ~/Downloads ~/nx \
  ~/.local/share/keyrings ~/.local/state \
  /run/media/wyattgill/BACKUP/zen/
```

There is **no external storage attached to this machine**. A USB stick, another host over
ssh, or cloud storage is required — a two-drive pool leaves no staging partition.

### 2. Push the flake

```sh
cd ~/nx && git status && git push
```

### 3. Boot a NixOS 26.11 installer

### 4. Confirm which drive is which — do not trust `nvme0`/`nvme1`

```sh
ls -l /dev/disk/by-id/ | grep KINGSTON
```

Expected serials: `…549C` → disko `a`, `…76466` → disko `b`.

### 5. Clone the config

```sh
nix-shell -p git --run 'git clone https://github.com/wyattgill9/nix-config /tmp/nx'
```

### 6. Partition, format, mount

```sh
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko -- --mode disko --flake /tmp/nx#zen
```

### 7. Verify the pool is what you asked for — before installing

```sh
sudo btrfs filesystem usage /mnt
sudo btrfs filesystem show
```

**Required:** `Data,single` and `Metadata,RAID1`, total ~1.85 TiB, two devices listed.
If it says `Data,RAID0`, stop — `-d single` did not take.

### 8. Passwords

```sh
sudo mkdir -p /mnt/persist/passwords
nix-shell -p mkpasswd --run 'mkpasswd -m sha-512' | sudo tee /mnt/persist/passwords/wyattgill
nix-shell -p mkpasswd --run 'mkpasswd -m sha-512' | sudo tee /mnt/persist/passwords/root
sudo chmod 600 /mnt/persist/passwords/*
```

### 9. Install

```sh
sudo nixos-install --flake /tmp/nx#zen --no-root-password
```

### 10. Reboot, then cap the games subvolume

```sh
sudo btrfs quota enable /
sudo btrfs qgroup limit 1.2T /games
```

### 11. Restore and re-add the Steam library

Restore the backup, then in Steam: Settings → Storage → add `/games` as a library folder.
Re-download games there. Set a download rate limit (~30 MB/s) so a future install cannot
starve the desktop.

---

## 8. Post-install verification

```sh
findmnt /                                  # expect: tmpfs
btrfs filesystem usage /                   # expect: Data,single  Metadata,RAID1
cat /etc/machine-id                        # must be stable across reboots
ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub   # must be stable
tailscale status                           # must still be authenticated
id wyattgill                               # uid must not drift
systemd-analyze blame | head               # tmpfiles-clean should no longer dominate
```

Then the real test — the one that caught this in the first place:

```sh
# under load, this should be single-digit milliseconds, not 318
dd if=/dev/zero of=/tmp/lat bs=4k count=50 oflag=direct,dsync; rm /tmp/lat
cat /proc/pressure/io                      # full avg60 should stay low
```

**Reboot twice and note what broke.** That is how you find the persist paths that were
missed. Everything mutable and undeclared is gone on each boot.

---

## 9. Phase 2 — home impermanence

Ship Phase 1 first: ephemeral `/` with `@home` persisted wholesale. That is the entire
structural win and it boots. Tighten `/home` afterwards, because home-level impermanence
is where the discovery pain lives — expect to find missing paths for a week.

`home-manager` is wired as a NixOS module in `hosts/zen/default.nix`, so
`inputs.impermanence.homeManagerModules.impermanence` works normally.

```nix
home.persistence."/persist/home/wyattgill" = {
  allowOther = true;
  directories = [
    ".ssh"
    ".local/share/keyrings"    # gnome-keyring — spotifast's Spotify grants live here
    ".local/state/nix"         # nix.settings.use-xdg-base-directories = true
    ".local/share/flatpak"
    ".local/share/Steam"       # client + config; the library itself lives in /games
    ".config/fcitx5"           # input method state
    ".claude"
    "nx"
    "Downloads" "Documents" "Pictures" "Videos"
  ];
  files = [ ".claude.json" ];
};
```

Deliberately **not** persisted: `.cache`. Those 23 GB evaporate on every boot — that is
the point.

---

## 10. Housekeeping

Unrelated to storage, worth doing while in here:

- **`flake.nix` has two sources of truth for home config** — `homeConfigurations."wyattgill@zen"`
  *and* `home-manager.users.wyattgill` via the NixOS module in `hosts/zen/default.nix`.
  They can drift. Pick the NixOS module and delete the standalone output.
- **Dead `libvirtd` group.** `users.users.wyattgill.extraGroups` includes `libvirtd`, but
  `virtualisation.libvirtd` is never enabled anywhere in this config.
- **`system.stateVersion = "24.05"`** on NixOS 26.11. Correct as-is — do not bump it.
- **Already configured, no action needed:** `nix.gc.automatic` (weekly, 30d) and
  `nix.settings.auto-optimise-store` are both set in `modules/nixos/nix-settings.nix`.
- **If waycast returns** (currently disabled in `modules/home/waycast.nix` pending an
  upstream rustc bump): it launched apps into its own daemon cgroup, pooling 1136 tasks
  and 24.5 GB together and defeating per-app resource limits. A launcher should spawn
  apps via `systemd-run --user --scope` so each gets its own cgroup.
