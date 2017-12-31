{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "arm-trusted-firmware-rk3328-bl31-1.4";

  src = fetchFromGitHub {
    owner =  "ARM-software";
    repo = "arm-trusted-firmware";
    rev = "v1.4";
    sha256 = "15m10dfgqkgw6rmzgfg1xzp1si9d5jwzyrcb7cp3y9ckj6mvp3i3";
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
