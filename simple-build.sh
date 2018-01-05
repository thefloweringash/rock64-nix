#/bin/sh -e

search_nix_path() {
    nix-instantiate --eval --expr "<$1>" 2>/dev/null
}

: ${nixpkgs:=$(search_nix_path nixpkgs)}

if [ ! -d "$nixpkgs" ]; then
    echo "Nixpkgs path not found"
    exit 1
fi

nixos=${nixpkgs}/nixos
echo "Using nixos=${nixos}"

build_package() {
    nix-build -E 'import <nixpkgs> { overlays = [ (import ./packages) ]; }' -A "$1"
}

## It can be useful to force these things to pass first

# build_package pkgs.rock64.linux_ayufan_4_4.src
# build_package pkgs.rock64.uboot.src
# build_package pkgs.rock64.idbloader

nix-build '<nixos>' \
    -I nixos=${nixos} \
    -I nixos-config=sd-image-rock64.nix \
    -A config.system.build.sdImage \
    -j1 # if building on an sd card
