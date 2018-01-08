#!/usr/bin/env nix-shell
#! nix-shell -i bash -p ncurses

set -e

make rockchip_linux_defconfig
NIX_CFLAGS_LINK+=" -lncurses"
export NIX_CFLAGS_LINK
make menuconfig
