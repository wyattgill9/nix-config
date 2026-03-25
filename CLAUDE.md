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
├── lib/default.nix
├── overlays/default.nix
├── hosts/
│   └── zen/
│       ├── default.nix
│       ├── hardware.nix
│       ├── disko.nix
│       ├── monitors.nix
│       └── home.nix
├── modules/
│   ├── nixos/
│   └── home/
├── home/
│   └── profiles/
├── secrets/
│   ├── secrets.nix
│   └── *.age
└── wallpapers/
```

## Architecture

- `flake.nix` defines the host/user metadata once and passes it through `specialArgs` / `extraSpecialArgs`.
- `hosts/zen/default.nix` is the NixOS entrypoint. It imports hardware, disko, agenix, nix-index-database, home-manager, and the shared `modules/nixos` tree.
- `hosts/zen/home.nix` is the Home Manager entrypoint. It imports `hosts/zen/monitors.nix` plus the desktop profile.
- `modules/nixos/` is host-agnostic system configuration. Every module is gated by `nx.nixos.<name>.enable`.
- `modules/home/` is split into `apps/`, `desktop/`, and `terminal/`.
- `home/profiles/linux.nix` is still the top-level composition layer for the user environment.

## Important Patterns

- Host-specific monitor/output layout belongs in `hosts/<host>/monitors.nix`, not inside the window manager modules.
- User identity, SSH keys, and the home directory come from flake args. Do not re-hardcode them inside modules.
- Keep `with pkgs;` scoped to package lists only.
- Prefer structured options when the module exposes them. Hyprland should use `settings`, not raw `extraConfig`.

## Secrets Workflow

Public keys live in `secrets/secrets.nix`. The repo includes encrypted placeholder files for:

- `secrets/tailscale-authkey.age`
- `secrets/user-password.age`

Create or replace a secret from `~/nx/secrets`:

```bash
printf 'your-secret-value\n' | RULES=./secrets.nix nix run github:ryantm/agenix -- -e tailscale-authkey.age
printf 'your-password-hash\n' | RULES=./secrets.nix nix run github:ryantm/agenix -- -e user-password.age
```

The live toggles are in `hosts/zen/default.nix`:

```nix
nx.nixos.security = {
  manageTailscaleAuthKey = false;
  manageUserPassword = false;
};
```

Keep them `false` until the placeholders are replaced with real values.

## Editing Guidance

- System packages live in `modules/nixos/packages.nix`.
- CLI tools live in `modules/home/terminal/tools.nix`.
- AI tools live in `modules/home/terminal/ai.nix` and are sourced from `github:numtide/llm-agents.nix`.
- Shared desktop session defaults live in `modules/home/desktop/common.nix`.
- If you add a new host, copy the `hosts/zen/` pattern instead of cloning module logic into a host-specific tree.
