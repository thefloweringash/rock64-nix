{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation {
  name = "rockchip_mpp";
  version = "release_20170811";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "mpp";
    rev = "release_20170811";
    sha256 = "1q9kivida906mk9ps6mrcqn5sjm91jz2wp1w08m85cnh6qijiz4g";
  };

  postPatch = ''
    substituteInPlace pkgconfig/rockchip_mpp.pc.cmake \
      --replace 'libdir=''${prefix}/'     'libdir=' \
      --replace 'includedir=''${prefix}/' 'includedir='

    substituteInPlace pkgconfig/rockchip_vpu.pc.cmake \
      --replace 'libdir=''${prefix}/'     'libdir=' \
      --replace 'includedir=''${prefix}/' 'includedir='
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = [ "-DCMAKE_RKPLATFORM_ENABLE=ON" ];

  outputs = [ "lib" "dev" "out" ];
}
