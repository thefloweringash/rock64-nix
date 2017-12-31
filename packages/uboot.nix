{ stdenv, fetchFromGitHub, buildUBoot, arm-trusted-firmware,
  bc, dtc, openssl, python2, swig }:

buildUBoot {
  src = fetchFromGitHub {
    owner =  "ayufan-rock64";
    repo = "linux-u-boot";
    rev = "ayufan-rock64/linux-build/0.6.5";
    sha256 = "087bxx7ck52jiay5d10w15dhchqw9phz38iqmjnjpjjb5id1vgck";
  };

  # buildUBoot defaults + swig
  nativeBuildInputs = [ bc dtc openssl python2 swig ];

  version = "ayufan-rock64-0.6.5";

  patches = [];

  postBuild= ''
    cp ${arm-trusted-firmware}/bl31.elf ./
    make u-boot.itb
  '';

  defconfig = "rock64-rk3328_defconfig";

  targetPlatforms = ["aarch64-linux"];

  # mkimage is needed by idbloader; ubootTools doesn't work
  filesToInstall = ["u-boot.itb" "spl/u-boot-spl.bin" "tools/mkimage"];
}
