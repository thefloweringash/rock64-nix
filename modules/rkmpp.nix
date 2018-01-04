{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [ (import ./../overlays/ffmpeg-rkmpp.nix) ];

  environment.systemPackages = [ pkgs.ffmpeg-full ];
}
