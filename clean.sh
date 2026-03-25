#!/usr/bin/env bash
set -e

read -p "Remove all old generations (yes/no): " confirm
[ "$confirm" != "yes" ] && exit 0

# Delete Generations
if [ -f /etc/NIXOS ]; then
    sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
else
    sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
fi
nix-env --delete-generations old
[ -d "$HOME/.local/state/nix/profiles" ] && \
    nix-env --delete-generations old --profile "$HOME/.local/state/nix/profiles/home-manager"

read -p "Collect garbage? (yes/no): " opt
if [ "$opt" == "yes" ]; then
    nix-collect-garbage -d
    sudo nix-collect-garbage -d 2>/dev/null || true
fi

read -p "Optimize store? (yes/no): " opt
[ "$opt" == "yes" ] && nix-store --optimise

# Clean Artifacts
find ~ -maxdepth 3 -name 'result*' -type l -delete 2>/dev/null || true
rm -rf /tmp/nix-{build,shell}-* "$HOME/.cache/nix" 2>/dev/null || true

echo "✓ Done"
