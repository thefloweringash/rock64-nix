#/bin/sh -e

build_package() {
    nix-build -E 'import <nixpkgs> { overlays = [ (import ./packages) ]; }' -A "$1" -o "$1"
}

# For updating an existing install
build_package rock64.idbloader

nix-build '<nixpkgs/nixos>' \
    -I nixos-config=sd-image-rock64.nix \
    -A config.system.build.sdImage \
    -j1 # if building on an sd card
