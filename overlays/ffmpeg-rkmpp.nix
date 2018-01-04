self: super:

let
  enableFfmpegRkmpp = ffmpeg: ffmpeg.overrideAttrs ({ configureFlags, buildInputs, ... }: {
    buildInputs = buildInputs ++ [ self.rockchip_mpp_20170811 self.libdrm ];
    configureFlags = configureFlags ++ [ "--enable-rkmpp" "--enable-libdrm" ];
  });
in

{
  ffmpeg = enableFfmpegRkmpp super.ffmpeg;
  ffmpeg-full = enableFfmpegRkmpp super.ffmpeg-full;
}
