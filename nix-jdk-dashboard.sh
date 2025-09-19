#!/bin/sh
# Output versions of select JDK packages for a specified Nixpkgs branch (default is nixpkgs-unstable)
set -e

ARG1=${1:-nixpkgs-unstable}

if [[ "$ARG1" == github:* ]]; then
    # If it starts with github: treat it as a full flake url
    FLAKE_URL="$ARG1"
else
    # Otherwise treat it as a branch of github:nixos/nixpkgs
    FLAKE_URL="github:nixos/nixpkgs/$ARG1"
fi

SYSTEM=`nix eval --impure --expr builtins.currentSystem`

TARGET_PATH=".#dashboard.${SYSTEM}"

echo "\nSearching $FLAKE_URL for $SYSTEM\n"  >&2
nix eval --json $TARGET_PATH --override-input nixpkgs $FLAKE_URL
