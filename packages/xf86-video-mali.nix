{ stdenv, buildEnv, xorg, autoreconfHook, pkgconfig, libdrm, fetchFromGitHub, fetchurl }:

let
  version = "r5p0-01rel0";

  maliDriverSource = stdenv.mkDerivation {
    name = "mali-ddk-${version}";
    inherit version;
    src = ./DX910-SW-99002-r5p0-01rel0.tgz;
    installPhase = ''
      mkdir $out
      cp -r driver/documentation driver/src $out
    '';
  };

  libump = stdenv.mkDerivation {
    name = "libump-${version}";
    inherit version;
    # src = ./DX910-SW-99006-r5p0-01rel0.tgz; # 404
    src = fetchFromGitHub {
      owner = "dsd";
      repo = "UMP";
      rev = "115616f22ced0b44a8fcb7d8c3729ee246fdf81a";
      sha256 = "18qxazzpalgiy5hj26dflzdld7ih3kljnvsxakn897j5wzx26if9";
    };

    postUnpack = "sourceRoot=$sourceRoot/driver/src/ump";

    buildPhase = ''
      make CROSS_COMPILE= CFLAGS="-Iinclude -Iinclude/ump -Wall"
    '';

    installPhase = ''
      mkdir -p $out/lib
      cp libUMP.so libUMP.a $out/lib

      cp -r include $out
    '';
  };

  compat-api = fetchurl {
    url = "https://cgit.freedesktop.org/~cooperyuan/compat-api/plain/compat-api.h";
    sha256 = "1ajib2ibcvfd0vbnvwm6wmxyf0j1k60prcwkb06v5crqp69s11mr";
  };

  # Reassemble the shape of the upstream DDK, which we can only fetch
  # in open source chunks.
  maliDDK = buildEnv {
    name = "mali-ddk";
    paths = [ maliDriverSource libump.src ];
  };
in

stdenv.mkDerivation {
  name = "xf86-video-mali-${version}";
  inherit version;
  src = ./DX910-SW-99003-r5p0-01rel0.tgz;

  nativeBuildInputs = [ autoreconfHook pkgconfig xorg.utilmacros ];
  buildInputs = [ libdrm libump ]
    ++ (with xorg; [ randrproto renderproto videoproto xproto fontsproto xorgserver ]);

  hardeningDisable = [ "bindnow" "relro" ];

  postUnpack = "sourceRoot=$sourceRoot/x11/xf86-video-mali-0.0.1";

  postPatch = ''
    cp ${compat-api} src/compat-api.h
    substituteInPlace src/Makefile.am \
      --replace 'MALI_DDK="/work/trunk"' 'MALI_DDK=${maliDDK}' \
      --replace '-lMali' ""
  '';

  patches = [
    ./libdrm-pkgconfig.patch
    ./x-server-include.patch
  ];
}

