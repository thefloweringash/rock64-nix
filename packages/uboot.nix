{ stdenv, fetchFromGitHub, fetchpatch, buildUBoot, arm-trusted-firmware }:

let
  sources = import ./ayufan-rock64-sources.nix;
in

buildUBoot {
  src = fetchFromGitHub {
    owner =  "ayufan-rock64";
    repo = "linux-u-boot";
    inherit (sources.linux-u-boot) rev sha256;
  };

  version = sources.version;

  patches = [
      (fetchpatch {
        url = https://github.com/dezgeg/u-boot/commit/cbsize-2017-11.patch;
        sha256 = "08rqsrj78aif8vaxlpwiwwv1jwf0diihbj0h88hc0mlp0kmyqxwm";
      })

      # Adapted from https://github.com/dezgeg/u-boot/commit/pythonpath-2017-11.patch
      ./uboot-python-path.patch
  ];

  postBuild= ''
    cp ${arm-trusted-firmware}/bl31.elf ./
    make u-boot.itb
  '';

  defconfig = "rock64-rk3328_defconfig";

  targetPlatforms = ["aarch64-linux"];

  # mkimage is needed by idbloader; ubootTools doesn't work
  filesToInstall = ["u-boot.itb" "spl/u-boot-spl.bin" "tools/mkimage"];
}
