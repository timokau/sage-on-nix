{pkgs, sage-src, fetchurl, stdenv, perl, gfortran6, autoreconfHook, gettext, hevea
, buildPythonPackage
, fetchFromGitHub
, arb
, openblas
, openblas-blas-pc
, openblas-cblas-pc
, openblas-lapack-pc
, brial
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

  # This has a cyclic dependency with sage. I don't include sage in the
  # buildInputs and let python figure it out at runtime. Because of this,
  # I don't include the package in the main nipxkgs tree. It wouldn't be useful
  # outside of sage anyways (as you could just directly depend on sage and use
  # it).
  pybrial = buildPythonPackage rec {
      pname = "pyBRiAl";
      version = "1.2.3";

      # included with BRiAl source
      src = fetchFromGitHub {
        owner = "BRiAl";
        repo = "BRiAl";
        rev = "${version}";
        sha256 = "0qy4cwy7qrk4zg151cmws5cglaa866z461cnj9wdnalabs7v7qbg";
      };

      preConfigure = "cd sage-brial";

      meta = with stdenv.lib; {
        description = "python implementation of BRiAl";
        license = licenses.gpl2;
        maintainers = with maintainers; [ timokau ];
      };
  };

  buildInputsWithoutPython = [ stdenv perl gfortran6 autoreconfHook gettext hevea
    arb
    openblas
    openblas-blas-pc
    openblas-cblas-pc
    openblas-lapack-pc
    brial
    pybrial
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
