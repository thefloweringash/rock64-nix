{ config, lib, pkgs, ... }:

{
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelParams = [
    "earlycon=uart8250,mmio32,0xff130000"
    "coherent_pool=1M"
    "ethaddr=\${ethaddr}"
    "eth1addr=\${eth1addr}"
    "serial=\${serial#}"
  ];

  services.mingetty.serialSpeed = [ 1500000 115200 ];

  # Ideally this would be run before the interface is brought up, but
  # that doesn't seem to be supported by the driver.
  systemd.services.rock64-fix-ethernet-offload = {
    description = "Disable offload for rock64 ethernet";
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -K eth0 rx off tx off";
    };
  };
}
