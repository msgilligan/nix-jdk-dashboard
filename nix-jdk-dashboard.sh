#!/bin/sh
# Output versions of select JDK packages for a specified Nixpkgs branch (default is nixpkgs-unstable)
BRANCH=${1:-nixpkgs-unstable}
NIXPKGS=github:NixOS/nixpkgs/$BRANCH
nix build .#jdk-dashboard --override-input nixpkgs $NIXPKGS
echo Results for $NIXPKGS
cat result | jq
