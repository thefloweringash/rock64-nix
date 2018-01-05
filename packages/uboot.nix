{ stdenv, fetchFromGitHub, fetchpatch, buildUBoot, arm-trusted-firmware }:

buildUBoot {
  src = fetchFromGitHub {
    owner =  "ayufan-rock64";
    repo = "linux-u-boot";
    rev = "ayufan-rock64/linux-build/0.6.9";
    sha256 = "00z3g2h28cdnammmrzqdg1ksnnm58ar7kgvmxyv9c2sr1gqkkawb";
  };

  version = "ayufan-rock64-0.6.9";

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
