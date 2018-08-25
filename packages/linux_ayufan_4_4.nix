{ stdenv, lib, fetchFromGitHub, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

let
  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-kernel";
    rev = "4.4.138-1094-rockchip-ayufan";
    sha256 = "0b5f15xdss48vjn71wcaiqmpmnfx4ccrcdrj5zbv1cb6d9zgx2cg";
  };

  version = "4.4.138";

  brokenFeatures = [
    "MALI_BIFROST"
    "POWERVR_ROGUE_M"
    "TOUCHSCREEN_GSL3673_800X1280"
    "VIDEO_IMX323"
    "VIDEO_OV9750"
    "RK30_CAMERA_PINGPONG"
    "CAMSYS_CIF"
    "RTL8723BS"
    "RTL8723DS"
    "PWM_CROS_EC"
    "RK_NANDC_NAND"
    "RK_SFC_NAND"
    "RK_SFC_NOR"
    "RK_NAND"
    "USB_DWC3_PCI"
    "BACKLIGHT_LM3630A"
    "FB_ROCKCHIP"
    "SND_SOC_CX20810"
    "SND_SOC_ROCKCHIP_MULTI_DAIS"
    "SND_SOC_ROCKCHIP_VAD"
    "COMPASS_MMC328X"
    "INV_MPU_IIO"
    "USB20_HOST"
    "USB20_OTG"

    # Something about VIDEOBUF2_DMA_CONTIG causes linker failures due
    # to undefined symbols and invalid relocations. It's automatically
    # selected by a lot of the V4L2 packages. Let's just turn off the
    # whole tree.
    "VIDEO_V4L2"
  ];

  disableFeatures = features:
    let
      inherit (import <nixpkgs/lib/kernel.nix> { inherit lib version; }) no;
    in  lib.listToAttrs (map (name: { inherit name; value = no; }) features);
in

buildLinux (args // rec {
  inherit src version;

  defconfig = "rockchip_linux_defconfig";

  structuredExtraConfig = disableFeatures brokenFeatures;
} // (args.argsOverride or {}))
