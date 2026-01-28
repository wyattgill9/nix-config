# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS/Home Manager dotfiles repository using Nix flakes. It manages configurations for multiple machines:
- **zen**: NixOS desktop (x86_64-linux) with full GUI environment (Hyprland/Sway)
- **mac**: macOS laptop (aarch64-darwin) with terminal-only configuration

## Build & Deployment Commands

```bash
# NixOS system rebuild (zen desktop)
sudo nixos-rebuild switch --flake ~/nx#zen

# Home Manager - Linux (zen)
home-manager switch --flake ~/nx#wyattgill@zen

# Home Manager - macOS
home-manager switch --flake ~/nx#wyattgill@mac

# Format all Nix files with alejandra
nix fmt

# Enter development shell (provides nixd LSP) - Should be automatic as we are using nix-direnv
nix develop

# Clean old generations and optimize store
./clean.sh
```

## Architecture

### Three-Layer Structure

1. **System Layer** (`modules/system/zen/`): NixOS system-level configuration
   - Bootloader, hardware, networking, locale, audio (PipeWire)
   - System services (SSH, printing, keyd)
   - Nix settings (garbage collection, substituters, flakes)
   - System-wide programs (Hyprland, Sway, Steam)

2. **Home Layer** (`home/modules/`): User-level configuration organized by category
   - `app/`: GUI applications (Discord, browsers, OBS, games)
   - `terminal/`: CLI tools (Fish, Helix, Tmux, Git, Jujutsu)
   - `wm/`: Window manager configs (Hyprland, Sway, Waybar, Rofi)

3. **Profile Layer** (`home/profiles/`): Composition of modules
   - `linux.nix`: Full desktop (app + terminal + wm)
   - `macos.nix`: Terminal-only (no GUI/WM)
   - `minimal.nix`: Empty placeholder

### Module Organization Pattern

Every module directory uses a `default.nix` aggregator:

```nix
{...}: {
  imports = [
    ./module1.nix
    ./module2.nix
    ./subfolder
  ];
}
```

This pattern cascades: profiles import module categories, module categories import individual modules.

### Host Configuration Pattern

**NixOS hosts** (`hosts/zen/`):
- `configuration.nix`: System config, imports system modules and home-manager as NixOS module
- `hardware.nix`: Auto-generated hardware configuration
- `home.nix`: User config, imports appropriate profile

**macOS hosts** (`hosts/macos/`):
- `home.nix`: User config only (no system-level configuration)

### Flake Input Integration

External packages are passed via `specialArgs`/`extraSpecialArgs`:

```nix
# In flake.nix
specialArgs = {inherit inputs;};

# In modules
{pkgs, inputs, ...}: {
  home.packages = [
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
}
```

**Current flake inputs:**
- awww, nix-flatpak, zen-browser, nixcord, fsel, rawgrep, nix-stalkr

### Configuration File Management

For apps with complex configs not exposed as Nix options:

```nix
home.file.".config/appname" = {
  source = ./.;        # Copy from module directory
  recursive = true;
};
```

Examples: `ghostty/`, `helix/`, `rofi/` store raw config files alongside module definitions.

### Cross-Platform Conditionals

```nix
# Package conditionals
package = if pkgs.stdenv.isLinux then pkgs.ghostty else null;

# Shell conditionals (Fish)
if test (uname) = "Darwin"
  # macOS-specific
end
```

## Common Workflows

### Adding a New Application

1. Create module in `home/modules/app/yourapp.nix`
2. Import in `home/modules/app/default.nix`
3. Rebuild: `home-manager switch --flake ~/nx#wyattgill@zen`

### Adding a New Host

1. Create `hosts/newhostname/` directory
2. Add `configuration.nix` (NixOS) or `home.nix` (any platform)
3. Create system modules in `modules/system/newhostname/` if needed
4. Add to `flake.nix` outputs:
   ```nix
   nixosConfigurations.newhostname = nixpkgs.lib.nixosSystem {
     specialArgs = {inherit inputs;};
     modules = [./hosts/newhostname/configuration.nix];
   };
   ```

### Adding a Flake Input

1. Add to `flake.nix` inputs section
2. Follow nixpkgs: `inputs.yourpkg.inputs.nixpkgs.follows = "nixpkgs";`
3. Update lock: `nix flake update yourpkg`
4. Use in modules via `inputs.yourpkg`

### Modifying System vs User Settings

- **System-level** (requires sudo rebuild): Edit `modules/system/zen/*.nix`
- **User-level** (home-manager rebuild): Edit `home/modules/**/*.nix`

## Special Patterns

### Home Activation Scripts

Post-installation hooks using home-manager's DAG:

```nix
home.activation.buildGrammars = lib.hm.dag.entryAfter ["writeBoundary"] ''
  export PATH=${pkgs.git}/bin:$PATH
  ${pkgs.helix}/bin/hx --grammar build
'';
```

Example: Helix grammar compilation in `home/modules/terminal/helix/default.nix`

### Security Wrappers

For privileged programs requiring capabilities:

```nix
# In modules/system/zen/programs.nix
security.wrappers.rawgrep = {
  owner = "root";
  group = "root";
  capabilities = "cap_dac_read_search=eip";
  source = "${inputs.rawgrep.packages.${pkgs.system}.default}/bin/rawgrep";
};
```

## File Locations

- System modules: `/home/wyattgill/nx/modules/system/zen/`
- User modules: `/home/wyattgill/nx/home/modules/{app,terminal,wm}/`
- Host configs: `/home/wyattgill/nx/hosts/{zen,macos}/`
- Profiles: `/home/wyattgill/nx/home/profiles/`
- Wallpapers: `/home/wyattgill/nx/wallpapers/`

## Key Technologies

- **Window Managers**: Hyprland (primary), Sway (rare alternative)
- **Terminal**: Ghostty, Foot
- **Shell**: Fish with Starship prompt
- **Editor**: Helix
- **VCS**: Git + Jujutsu (jj)
- **Audio**: PipeWire
- **Display Server**: Wayland
