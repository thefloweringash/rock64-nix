{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [(self: super: {
    xorg = super.xorg // {
      xf86videomali = self.rock64.xf86videomali;
    };
  })];

  services.xserver.videoDrivers = [ "mali" ];
}
