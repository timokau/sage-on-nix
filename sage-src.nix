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
  ];

  buildInputs = [];

  configurePhase = "true";

  # TODO patch file
  buildPhase = ''
    substituteInPlace build/bin/sage-pip-install \
        --replace 'out=$(' 'break #' \
        --replace '$PIP-lock SHARED install' '$PIP install --prefix="$out" --no-cache' \
        --replace '[[ "$out" != *"not installed" ]]' 'false'

    echo -n 'python "$@"' > build/bin/sage-python23
  '';

  installPhase = ''
    cp -r . "$out"
  '';
}
