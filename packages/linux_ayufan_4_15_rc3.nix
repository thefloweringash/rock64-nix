{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

# TODO: this uses nixpkgs, nowhere else in this repo does
# Is the generic builder exported anywhere?
import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.15-rc3-ayufan-rock64";
  modDirVersion = "4.15.0-rc3";

  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-mainline-kernel";
    rev = "ayufan-rock64/linux-build/0.6.5";
    sha256 = "06pnphxw8lgi3jpad3czqz3fm4pc2liwin1w4v2gqqn985hhv1nb";
  };
} // (args.argsOverride or {}))

