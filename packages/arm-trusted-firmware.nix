{ stdenv, fetchFromGitHub }:

let
  sources = import ./ayufan-rock64-sources.nix;
in

stdenv.mkDerivation {
  name = "arm-trusted-firmware-rk3328-bl31-${sources.version}";
  version = sources.version;

  src = fetchFromGitHub {
    owner =  "ayufan-rock64";
    repo = "arm-trusted-firmware";
    inherit (sources.arm-trusted-firmware) rev sha256;
  };

  hardeningDisable = [ "all" ];
  dontStrip = true;

  buildPhase = ''
    make PLAT=rk3328 bl31
  '';

  installPhase = ''
    mkdir $out/
    cp build/rk3328/release/bl31/bl31.elf $out/
  '';
}
