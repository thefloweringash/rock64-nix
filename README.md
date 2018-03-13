# NixOS on Rock64

This project is a fairly straightforward port of [ayufan][]'s
[rock64][] project to NixOS.


[ayufan]: https://github.com/ayufan
[rock64]: https://github.com/ayufan-rock64/

## Status

Weekend hobby project. Works for me.

## Building

```
nix-build release.nix -A sdImage
```

## Installation

Dump image to SD card. Insert into rock64. Boot.

The image includes UBoot with "Generic Distro Configuration" support.

## Post installation configuration

Use the standard nixos-generate-config command to generate the
hardware and filesystem configuration file. In the main configuration
file (`configuration.nix`), include the two modules from this
repository's `modules/` directory, which adds in the kernel package,
and some sensible defaults. In you main configuration.nix, specify
your desired kernel. For example:

```
{ config, lib, pkgs, ... }:
{
  include = [
    ./rock64-nix/modules/rock64-configuration.nix
    ./rock64-nix/modules/packages.nix
  ];

  boot.kernelPackages = pkgs.rock64.linuxPackages_ayufan_4_4;
}
```
