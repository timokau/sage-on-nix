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
# , python3
, ratpoints
, readline
, rw
, singular
, six
, symmetrica
, zn_poly
, zlib
, fflas_ffpack
, markupsafe
, gmp
, boost_cropped
, gc
}:
pkgs.stdenv.mkDerivation rec {
  version = "1.2.3.47"; # TODO
  name = "sagelib-${version}";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = "8.1";
    sha256 = "035qvag43bmcwr9yq4qywx7pphzldlb6a0bwldr01qbgv3ny5j40";
  };

  patches = [
    ./pkgconfig-set.patch
    ./no-jupyter-kernel.patch
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
    zlib
    fflas_ffpack
    markupsafe
    gmp
    boost_cropped
    gc
];
  propagatedBuildInputs = buildInputs;
  nativeBuildInputs = buildInputs; # TODO figure out why this is necessary (for openblas and gfortran)

  configurePhase = ''
  # NOOP
  '';

  # TODO
  autoreconfPhase = ''
  # NOOP
  '';

  # environment variables for the build
  SAGE_ROOT = src;
  SAGE_LOCAL = placeholder "out"; # TODO build somewhere else
  SAGE_SHARE = SAGE_LOCAL + "/share";
  MAKE = "make";

  #TODO write_script_wrapper
  buildPhase = ''
    echo -n 'python "$@"' > build/bin/sage-python23
    substituteInPlace build/bin/sage-pip-install \
        --replace 'out=$(' 'break #' \
        --replace '$PIP-lock SHARED install' 'echo $PIP install --prefix="$out" --no-cache' \
        --replace '[[ "$out" != *"not installed" ]]' 'false'

    export PATH="$PWD/build/bin":"$PWD/src/bin":"$PATH"

    cat <( echo '# distutils: libraries = gd' ) src/sage/matrix/matrix_mod2_dense.pxd > src/sage/matrix/matrix_mod2_dense.pdx

    cd src

    export DISTUTILS_DEBUG=1
    export SAGE_NUM_THREADS=4 # TODO
    mkdir -p $out/{share,bin,include,lib}
    mkdir -p $out/var/lib/sage/installed
    source bin/sage-dist-helpers


    sage-python23 -u setup.py --no-user-cfg build
  '';

  postPatch = ''
    substituteInPlace src/sage/env.py \
        --replace 'SINGULAR_SO = SAGE_LOCAL+"/lib/libSingular."+extension' 'SINGULAR_SO = "${singular}/lib/libSingular.so"'
  '';

  installPhase = ''
    sage-python23 -u setup.py --no-user-cfg install --prefix=$out
    cp bin/sage "$out"/bin
  '';

  postInstall = ''
    rm -f "$SAGE_LOCAL"/lib/*.la
  '';
}
