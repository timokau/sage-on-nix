{ stdenv
, fetchurl
, unzip
, unpacked_sage
}:
{ spkg_name
, spkg_version
, filename
}:
stdenv.mkDerivation rec {
  version = "${spkg_version}";
  name = "spkg-${spkg_name}-${version}-src";
  sage_version = "8.0";

  src = "${unpacked_sage}/upstream/${filename}";

  configurePhase = "echo nothing to configure";
  patchPhase = "echo nothing to patch";

  buildInputs = [
    unzip
  ];

  buildPhase = ''
    # NOOP
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r "${unpacked_sage}/build/pkgs/${spkg_name}/"* "$out"
    dir=$PWD
    cd ..
    mv "$dir" "$out/src"
  '';
}
