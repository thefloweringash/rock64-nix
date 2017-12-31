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
}
