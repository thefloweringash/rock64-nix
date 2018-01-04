self: super:
let buildLinuxWithPython = (args: (super.buildLinux args).overrideAttrs ({ nativeBuildInputs, ... }: {
      nativeBuildInputs = nativeBuildInputs ++ [ self.python ];
    }));
in
{
  # Packages fairly unique to the rock64
  rock64 = {
    # rkbin is the exception: not unique to the rock64, but limited in scope to
    # boot images.
    rkbin = super.callPackage ./rkbin.nix {};

    arm-trusted-firmware = super.callPackage ./arm-trusted-firmware.nix {};

    uboot = super.callPackage ./uboot.nix {
      inherit (self.rock64) arm-trusted-firmware;
    };

    idbloader = super.callPackage ./idbloader.nix {
      inherit (self.rock64) uboot rkbin;
    };

    linux_ayufan_4_4 = super.callPackage ./linux_ayufan_4_4.nix {
      kernelPatches = with self; [
        kernelPatches.bridge_stp_helper
        kernelPatches.cpu-cgroup-v2."4.4"
        kernelPatches.modinst_arg_list_too_long
      ];
    };

    linuxPackages_ayufan_4_4 = super.linuxPackagesFor self.rock64.linux_ayufan_4_4;

    linux_ayufan_4_15_rc3 = super.callPackage ./linux_ayufan_4_15_rc3.nix {
      kernelPatches = with self; [
        kernelPatches.bridge_stp_helper
        kernelPatches.modinst_arg_list_too_long
      ];
    };

    linuxPackages_ayufan_4_15_rc3 = super.linuxPackagesFor self.rock64.linux_ayufan_4_15_rc3;

  };

  # More generally applicable packages
  rockchip_mpp_20170811 = super.callPackage ./rockchip_mpp_20170811.nix {};
  rockchip_mpp_20171218 = super.callPackage ./rockchip_mpp_20171218.nix {};
}
