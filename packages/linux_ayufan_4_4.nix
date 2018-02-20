{ stdenv, hostPlatform, fetchFromGitHub, linuxManualConfig, python, kernelPatches ? [] }:

let
  linuxManualConfigWithPython = (args: (linuxManualConfig args).overrideAttrs ({ nativeBuildInputs, ... }: {
    nativeBuildInputs = nativeBuildInputs ++ [ python ];
    postPatch = ''
      patchShebangs .
    '';
  }));

  sources = import ./ayufan-rock64-sources.nix;

  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-kernel";
    inherit (sources.linux-kernel) rev sha256;
  };
   
  buildInputs = [ python ];

  postPatch = ''
    patchShebangs .
  '';

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

linuxManualConfigWithPython {
  inherit stdenv kernelPatches hostPlatform;

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
