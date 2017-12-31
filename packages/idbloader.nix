{ stdenv, rkbin, uboot }:

stdenv.mkDerivation {
  name = "u-boot-idbloader-0.6.5";

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    ${uboot}/mkimage -n rk3328 -T rksd -d ${rkbin}/rk33/rk3328_ddr_786MHz_v1.06.bin idbloader.img
    cat ${uboot}/u-boot-spl.bin >> idbloader.img
    dd if=${uboot}/u-boot.itb of=idbloader.img seek=$((0x200-64)) conv=notrunc
  '';

  installPhase = ''
    cp idbloader.img $out
  '';
}
