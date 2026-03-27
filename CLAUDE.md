# CLAUDE.md

This repository is a NixOS/Home Manager flake for `zen`, organized around shared modules and small host-specific entrypoints.

## Primary Commands

```bash
nix fmt .
nix flake check

home-manager build --flake ~/nx#wyattgill@zen
home-manager switch --flake ~/nx#wyattgill@zen

sudo nixos-rebuild build --flake ~/nx#zen
sudo nixos-rebuild switch --flake ~/nx#zen
```

## Layout

```text
~/nx
├── flake.nix
├── overlays/default.nix
├── hosts/
│   └── zen/
│       ├── default.nix
│       ├── hardware.nix
│       ├── disko.nix
│       └── home.nix
├── modules/
│   ├── nixos/
│   └── home/
├── home/
│   └── profiles/
└── wallpapers/
```

## Architecture

- `flake.nix` defines the host/user metadata once and passes it through `specialArgs` / `extraSpecialArgs`.
- `hosts/zen/default.nix` is the NixOS entrypoint. It imports hardware, disko, nix-index-database, home-manager, and the shared `modules/nixos` tree.
- `hosts/zen/home.nix` is the Home Manager entrypoint. It imports the desktop profile.
- `modules/nixos/` is host-agnostic system configuration.
- `modules/home/` is split into `apps/`, `desktop/`, and `terminal/`.
- `modules/home` is the top-level shared composition layer for the user environment.

## Important Patterns

- Keep `with pkgs;` scoped to package lists only.
- Prefer structured options when the module exposes them. Hyprland should use `settings`, not raw `extraConfig`.

## Editing Guidance

- System packages live in `modules/nixos/packages.nix`.
- CLI tools live in `modules/home/terminal/tools.nix`.
- AI tools live in `modules/home/terminal/ai.nix` and are sourced from `github:numtide/llm-agents.nix`.
- Shared desktop session defaults live in `modules/home/desktop/common.nix`.
- If you add a new host, copy the `hosts/zen/` pattern instead of cloning module logic into a host-specific tree.
