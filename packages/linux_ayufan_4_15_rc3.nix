{ stdenv, hostPlatform, fetchFromGitHub, perl, linuxManualConfig, ... } @ args:

let
  sources = import ./ayufan-rock64-sources.nix;
in

# TODO: this uses nixpkgs, nowhere else in this repo does
# Is the generic builder exported anywhere?
import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.15-rc3-ayufan-rock64";
  modDirVersion = "4.15.0-rc3";

  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-mainline-kernel";
    inherit (sources.linux-kernel-mainline) rev sha256;
  };
} // (args.argsOverride or {}))

