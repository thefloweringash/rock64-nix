{ stdenv, lib, hostPlatform, fetchFromGitHub, linuxManualConfig, python, features ? {}, kernelPatches ? [] }:

# Additional features cannot be added to this kernel
assert features == {};

let
  passthru = { features = {}; };

  version = "4.4.138-1094-rockchip-ayufan";

  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-kernel";
    rev = version;
    sha256 = "0b5f15xdss48vjn71wcaiqmpmnfx4ccrcdrj5zbv1cb6d9zgx2cg";
  };

  extraOptions = {
    BINFMT_MISC = "y";
  };

  configfile = stdenv.mkDerivation {
    name = "ayufan-rock64-linux-kernel-config-${version}";
    version = version;
    inherit src;

    buildPhase = ''
      make rockchip_linux_defconfig

      cat > arch/arm64/configs/nixos_extra.config <<EOF
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (n: v: "CONFIG_${n}=${v}") extraOptions
      )}
      EOF

      make nixos_extra.config
    '';

    installPhase = ''
      cp .config $out
    '';
  };

  drv = linuxManualConfig {
    inherit stdenv kernelPatches;
    inherit hostPlatform;

    inherit src;

    inherit version;
    modDirVersion = "4.4.138";

    inherit configfile;

    allowImportFromDerivation = true; # Let nix check the assertions about the config
  };

in

stdenv.lib.extendDerivation true passthru drv
