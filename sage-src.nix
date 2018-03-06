{pkgs, fetchFromGitHub, stdenv }:
pkgs.stdenv.mkDerivation rec {
  version = "8.1"; # TODO
  name = "sage-src-${version}";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = "8.1";
    sha256 = "035qvag43bmcwr9yq4qywx7pphzldlb6a0bwldr01qbgv3ny5j40";
  };

  patches = [
    # Make pkgconfig return lists instead of sets
    ./patches/sagelib/pkgconfig-set.patch
    ./patches/sagelib/spkg-paths.patch
    # FIXME
    ./patches/sagelib/no-jupyter-kernel.patch
    ./patches/sagelib/maxima-absolute-paths.patch
    # Tests in nix unnecessary behaviour
    ./patches/sagelib/disable-refusing-doctests-test.patch
    ./patches/sagelib/remove-python-workarounds.patch
    ./patches/sagelib/doctest-silence-cache-warning.patch
    ./patches/sagelib/python3-syntax-warning-lenient.patch
    ./patches/sagelib/remove-sage-started.patch
    ./patches/sagelib/qepcad-config-optional.patch
    ./patches/sagelib/respect-jupyter-path.patch
  ];

  buildInputs = [];

  configurePhase = "true";

  buildPhase = "true";

  installPhase = ''
    cp -r . "$out"
  '';
}
