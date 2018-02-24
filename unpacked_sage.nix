{ stdenv
, fetchurl
}:
stdenv.mkDerivation rec {
  version = "8.1";
  name = "sage-src-${version}";

  src = fetchurl {
    url = "http://mirrors.mit.edu/sage/src/sage-${version}.tar.gz";
    sha256 = "1a9rhb8jby6fdqa2s7n2fl9jwqqlsl7qz7dbpbwvg6jwlrvnifff";
  };

  configurePhase = "echo nothing to configure";
  patchPhase = "echo nothing to patch";

  buildPhase = ''
    # NOOP
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -ar * "$out"
  '';
}
