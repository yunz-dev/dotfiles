#!/usr/bin/env bash
#
# A rebuild script that commits on a successful build
# Based on Vimjoyer's nixos-rebuild script, adapted for nix-darwin

set -e

# cd to your config dir
pushd ~/nix/

# Store hash of flake before editing
ORIGINAL_HASH=$(sha256sum flake.nix | cut -d' ' -f1)

# Edit your config
$EDITOR flake.nix

# Early return if no changes were detected
NEW_HASH=$(sha256sum flake.nix | cut -d' ' -f1)
if [[ "$ORIGINAL_HASH" == "$NEW_HASH" ]]; then
  echo "No changes detected, exiting."
  popd
  exit 0
fi

# Autoformat your nix files
alejandra . &>/dev/null ||
  (
    alejandra .
    echo "formatting failed!" && exit 1
  )

# Show diff against dotfiles repo version
echo "Changes:"
diff -u ~/dotfiles/nix/flake.nix flake.nix || true

echo "Darwin Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo darwin-rebuild switch --flake ~/nix\#pro &>darwin-switch.log || (cat darwin-switch.log | grep --color error && exit 1)

echo "Build successful! Copying to dotfiles repo..."

# Copy the working config to dotfiles repo
cp -r ~/nix/* ~/dotfiles/nix/

# cd to dotfiles repo to commit
popd
pushd ~/dotfiles/nix/

# Get current generation metadata
current=$(sudo darwin-rebuild --list-generations | grep current)

# Commit all changes with the generation metadata
git commit -am "nix-darwin: $current"

# Back to where you were
popd

# Notify all OK!
echo "Darwin Rebuilt OK!"
