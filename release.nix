with (import <nixpkgs/nixos> {
  configuration = ./sd-image-rock64.nix;
});

{
  inherit (config.system.build)
    kernel
    toplevel
    sdImage
    ;
}
