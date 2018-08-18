{ stdenv, fetchFromGitHub, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // {
  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-kernel";
    rev = "4.4.138-1094-rockchip-ayufan";
    sha256 = "0b5f15xdss48vjn71wcaiqmpmnfx4ccrcdrj5zbv1cb6d9zgx2cg";
  };

  version = "4.4.138";

  defconfig = "rockchip_linux_defconfig";
} // (args.argsOverride or {}))
