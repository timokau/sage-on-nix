{pkgs, sage-src, fetchurl, stdenv, perl, gfortran6, autoreconfHook, gettext, hevea
, arb
, openblas
, openblas-blas-pc
, openblas-cblas-pc
, openblas-lapack-pc
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
, six
, symmetrica
, zn_poly
, zlib
, fflas_ffpack
, markupsafe
, gmp
, boost_cropped
, gc
, singular
}:
# TODO autoreconf -vi
# TODO configure --prefix=...
# TODO --optimize
pkgs.stdenv.mkDerivation rec {
  version = "8.1"; # TODO
  name = "sagelib-${version}";

  src = sage-src;

  buildInputsWithoutPython = [ stdenv perl gfortran6 autoreconfHook gettext hevea
    arb
    openblas
    openblas-blas-pc
    openblas-cblas-pc
    openblas-lapack-pc
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
    ratpoints
    readline
    rw
    six
    symmetrica
    zn_poly
    zlib
    fflas_ffpack
    markupsafe
    gmp
    boost_cropped
    gc
    singular
  ];

  # TODO
  buildInputs = buildInputsWithoutPython ++ [
    (python3.withPackages (ps: with ps; buildInputsWithoutPython ))
    (python2.withPackages (ps: with ps; buildInputsWithoutPython ))
  ];
  propagatedBuildInputs = buildInputsWithoutPython;
  nativeBuildInputs = buildInputs; # TODO figure out why this is necessary (for openblas and gfortran)


  # environment variables for the build
  SAGE_ROOT = src;
  SAGE_LOCAL = placeholder "out"; # TODO build somewhere else
  SAGE_SHARE = SAGE_LOCAL + "/share";
  JUPYTER_PATH = SAGE_LOCAL + "/jupyter";
  MAKE = "make";

  buildPhase = ''
    export PATH="$PWD/build/bin":"$PWD/src/bin":"$PATH"

    cd src

    export SAGE_NUM_THREADS="$NIX_BUILD_CORES"
    mkdir -p $out/{share,bin,include,lib}
    mkdir -p $out/var/lib/sage/installed
    source bin/sage-dist-helpers


    sage-python23 -u setup.py --no-user-cfg build
  '';

  installPhase = ''
    sage-python23 -u setup.py --no-user-cfg install --prefix=$out
    cp bin/sage "$out"/bin
  '';

  postInstall = ''
    rm -f "$SAGE_LOCAL"/lib/*.la
  '';
}
