{ stdenv, fetchFromGitHub, buildLinux, python, kernelPatches ? [] }:

let
  buildLinuxWithPython = (args: (buildLinux args).overrideAttrs ({ nativeBuildInputs, ... }: {
    nativeBuildInputs = nativeBuildInputs ++ [ python ];
  }));

  sources = import ./ayufan-rock64-sources.nix;

  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-kernel";
    inherit (sources.linux-kernel) rev sha256;
  };

  configfile = stdenv.mkDerivation {
    name = "ayufan-rock64-linux-kernel-config-${sources.version}";
    version = sources.version;
    inherit src;

    patches = [ ./linux_ayufan_4_4_defconfig.patch ];

    buildPhase = ''
      make rockchip_linux_defconfig
    '';

    installPhase = ''
      cp .config $out
    '';
  };

in

buildLinuxWithPython {
  inherit stdenv kernelPatches;

  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-kernel";
    inherit (sources.linux-kernel) rev sha256;
  };

  version = "4.4.103-ayufan-rock64";
  modDirVersion = "4.4.103";

  inherit configfile;

  allowImportFromDerivation = true; # Let nix check the assertions about the config
}
