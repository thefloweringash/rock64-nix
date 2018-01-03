# WORK IN PROGRESS - THIS DOES NOT WORK

# xf86-video-mali driver

Trying very hard to match driver versions end to end. The kernel we're
targetting (linux ayufan 4.4.103) has r5p0-01rel0 in the tree. To build this,
fetch:

- driver source (DX910-SW-99002-r5p0-01rel0.tgz) from
  https://developer.arm.com/products/software/mali-drivers/utgard-kernel

- libump (DX910-SW-99006-r5p0-01rel0.tgz) from
  https://developer.arm.com/products/software/mali-drivers/ump-user-space

  Note this is presently a 404. Instead the build will fetch from a
  random github mirror.

- xf86-video-mali (DX910-SW-99003-r5p0-01rel0.tgz) from
  https://developer.arm.com/products/software/mali-drivers/display-drivers

And place them alongside the .nix files

# Future Work

Rockchip publishes their libmali binaries on github at
https://github.com/rockchip-linux/libmali.  It should be possible to build the
entire stack around (libmali-utgard-450-r7p0-*), and have fully functioning
acceleration. At first glance, the `mali_drm` module, while very simple, hasn't
been updated to linux-3.4.
