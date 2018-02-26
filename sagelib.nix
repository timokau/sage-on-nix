{pkgs, fetchFromGitHub, fetchurl, stdenv, perl, gfortran6, autoreconfHook, gettext, hevea
, arb
, openblas
, brial
, cephes
, cliquer
, cypari
, cysignals
, cython
, ecl
, eclib
, ecm
, flint
, libgd
, givaro
, glpk
, gsl
, iml
, jinja2
, jupyter_core
, lcalc
, lrcalc
, libgap
, libpng
, linbox
, m4ri
, m4rie
, mpc
, mpfi
, mpfr
, mpir
, ntl
, numpy
, pari
, pip
, pkgconfig
, planarity
, ppl
, pynac
, python2
, python3
, ratpoints
, readline
, rw
, singular
, six
, symmetrica
, zn_poly
}:
pkgs.stdenv.mkDerivation rec {
  version = "1.2.3.47"; # TODO
  name = "sagelib-${version}";

  sage-src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = "8.1";
    sha256 = "035qvag43bmcwr9yq4qywx7pphzldlb6a0bwldr01qbgv3ny5j40";
  };
  src=sage-src;

  patches = [
    ./pkgconfig-set.patch
  ];

  buildInputs = [ stdenv perl gfortran6 autoreconfHook gettext hevea
    arb
    openblas
    brial
    cephes
    cliquer
    cypari
    cysignals
    cython
    ecl
    eclib
    ecm
    flint
    libgd
    givaro
    glpk
    gsl
    iml
    jinja2
    jupyter_core
    lcalc
    lrcalc
    libgap
    libpng
    linbox
    m4ri
    m4rie
    mpc
    mpfi
    mpfr
    mpir
    ntl
    numpy
    pari
    pip
    pkgconfig
    planarity
    ppl
    pynac
    python2
    # python3
    ratpoints
    readline
    rw
    singular
    six
    symmetrica
    zn_poly
];
  propagatedBuildInputs = buildInputs;
  nativeBuildInputs = buildInputs; # TODO figure out why this is necessary (for openblas and gfortran)

  hardeningDisable = [ "format" ]; # TODO palp

  sourceRoot = "."; # don't cd into the directory after unpack

  postUnpack = ''
    cp -r ${sage-src}/build/bin build-scripts
    chmod -R 777 build-scripts
    echo -n 'python "$@"' > build-scripts/sage-python23
    substituteInPlace build-scripts/sage-pip-install \
        --replace 'out=$(' 'break #' \
        --replace '$PIP-lock SHARED install' 'echo $PIP install --prefix="$out" --no-cache' \
        --replace '[[ "$out" != *"not installed" ]]' 'false'

    cp -r ${sage-src}/src/bin src-scripts

    export PATH="$PWD/build-scripts":"$PWD/src-scripts":"$PATH"

    cd source
  '';

  configurePhase = ''
  # NOOP
  '';

  # TODO
  autoreconfPhase = ''
  # NOOP
  '';

  # environment variables for the build
  SAGE_ROOT = sage-src;
  SAGE_LOCAL = placeholder "out"; # TODO build somewhere else
  SAGE_SHARE = SAGE_LOCAL + "/share";
  MAKE = "make";

  #TODO write_script_wrapper
  buildPhase = ''
    mkdir -p $out/{share,bin,include,lib}
    mkdir -p $out/var/lib/sage/installed
    source ${sage-src}/src/bin/sage-dist-helpers
  '';

  installPhase = ''
    cd src
    substituteInPlace sage/env.py \
        --replace 'SINGULAR_SO = SAGE_LOCAL+"/lib/libSingular."+extension' 'SINGULAR_SO = "${singular}/lib/libSingular.so"'
    sage-python23 -u setup.py --no-user-cfg build install --prefix=$out
  '';

  postInstall = ''
    rm -f "$SAGE_LOCAL"/lib/*.la
  '';
}
