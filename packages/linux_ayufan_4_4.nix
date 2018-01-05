{ stdenv, fetchFromGitHub, buildLinux, python, kernelPatches ? [] }:

let buildLinuxWithPython = (args: (buildLinux args).overrideAttrs ({ nativeBuildInputs, ... }: {
      nativeBuildInputs = nativeBuildInputs ++ [ python ];
    }));
in
buildLinuxWithPython {
  inherit stdenv kernelPatches;

  version = "4.4.103-ayufan-rock64";
  modDirVersion = "4.4.103";

  # Config file is
  #    make rockchip_linux_defconfig
  #    + CONFIG_DMIID
  #    + CONFIG_AUTOFS4
  #    + CONFIG_BINFMT_MISC
  configfile = ./linux_ayufan_4_4_config;

  allowImportFromDerivation = true; # Let nix check the assertions about the config

  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-kernel";
    rev = "ayufan-rock64/linux-build/0.6.9";
    sha256 = "0qgjy54pxwk4g78fjl3zyk1aywx2y4njp4lk9xixmi52gbzmyk9q";
  };
}
