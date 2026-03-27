# nx

NixOS configuration for my daily-driver desktop — a single-host flake on `nixos-unstable`.

## Structure

```
flake.nix              # Inputs, outputs, host metadata
hosts/zen/
  default.nix          # System config, user, module imports
  home.nix             # Home-manager entry point
  hardware.nix         # Generated hardware config (AMD/NVME)
  disko.nix            # Disk layout (GPT, 512M ESP + ext4 root)
modules/
  nixos/               # System-level modules
  home/                # User-level modules (terminal, desktop, apps)
wallpapers/            # Wallpaper collection
```

## Host: zen

AMD desktop, x86_64, single NVME drive. Boots with systemd-boot and the `linux_zen` kernel.

**Desktop** — Hyprland (Wayland) with Waybar, Rofi, Dunst, and Ghostty as the primary terminal. Catppuccin/TokyoNight theming throughout.

**Dev tools** — Fish shell, Helix editor, Jujutsu (primary VCS), Neovim, ripgrep, fzf, bat, tmux, Claude Code.

**Apps** — Zen Browser, Discord (Nixcord), Spotify, OBS, Steam + Gamescope, Anki, Lunar Client.

**System** — PipeWire audio, fcitx5 input method, Tailscale VPN, NetworkManager with static IP, Fail2ban + SSH hardening, Flatpak for edge cases.

## Inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | nixos-unstable package set |
| `home-manager` | User environment management |
| `disko` | Declarative disk partitioning |
| `nix-index-database` | Command-not-found lookup |
| `nix-flatpak` | Flatpak integration |
| `awww` | Wayland wallpaper daemon |
| `llm-agents` | Claude/Codex |
| `zen-browser` | Zen Browser |
| `nixcord` | Discord with plugins |

## Usage

Rebuild the system:

```sh
sudo nixos-rebuild switch --flake .#zen
```
