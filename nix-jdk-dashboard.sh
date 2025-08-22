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

echo
echo Searching $FLAKE_URL
echo
nix build .#jdk-dashboard --override-input nixpkgs $FLAKE_URL
cat result | jq
