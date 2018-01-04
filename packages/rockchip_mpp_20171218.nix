{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  name = "rockchip_mpp";
  version = "release_20171218";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "mpp";
    rev = "release_20171218";
    sha256 = "0hdkk3p2fn03phhc5980sl0fg771fs2sk49wgasj4i0ax8hidg80";
  };

  postPatch = ''
    substituteInPlace pkgconfig/rockchip_mpp.pc.cmake \
      --replace 'libdir=''${prefix}/'     'libdir=' \
      --replace 'includedir=''${prefix}/' 'includedir='

    substituteInPlace pkgconfig/rockchip_vpu.pc.cmake \
      --replace 'libdir=''${prefix}/'     'libdir=' \
      --replace 'includedir=''${prefix}/' 'includedir='
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DRKPLATFORM=ON" ];

  outputs = [ "lib" "dev" "out" ];
}
