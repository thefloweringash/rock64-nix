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
    rev = "ayufan-rock64/linux-build/0.6.5";
    sha256 = "1cypiy0l9kj7mc40sysbd081dwlx5ldaj4hpypi7vrjjl4mzs3pa";
  };
}
