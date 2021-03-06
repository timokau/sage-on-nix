{ pkgs
, stdenv
, sage-src
, sagelib
, pygments
, ipython_5
, traitlets
, enum34
, ipython_genutils
, decorator
, pexpect
, ptyprocess
, backports_shutil_get_terminal_size
, pathlib2
, pickleshare
, prompt_toolkit
, wcwidth
, simplegeneric
, openblasCompat
, openblas-blas-pc
, openblas-cblas-pc
, openblas-lapack-pc
, pkgconfig
, psutil
, future
, singular
, sympy
, mpmath # TODO propagated by sympy
, fpylll
, libgap
, gap
, matplotlib
, scipy
, pyparsing
, cycler
, networkx
, dateutil # TODO propagated by matplotlib
, conway_polynomials
, graphs
, ecl
, pillow
, twisted
, cvxopt
, ipykernel
, ipywidgets
, rpy2
, sphinx
, sagenb
, docutils
, jupyter_client
, flask
, flask-babel
, flask-oldsessions
, flask-autoindex
, flask-openid
, flask-silk
, werkzeug # for notebook
, typing
, pyzmq
, zope_interface # for twisted
, itsdangerous # flask
, Babel # sphinx
, pytz
, speaklater # sagenb
, tornado
, imagesize
, requests
, gcc
, palp
, R
, giac
, polytopes_db
, combinatorial_designs
, alabaster
, three
, tachyon
, jmol
, elliptic_curves
, maxima-ecl
, cddlib
, glpk
, pari
, pari_data
, gmp
, sympow
, gfan
, sqlite
, python3
, python2
, rubiks
, snowballstemmer
, flint
}:
stdenv.mkDerivation rec {
  version = "8.1"; # TODO
  name = "sagedoc-${version}";

  src = sage-src; # TODO

  # TODO abstract sage deps
  buildInputsWithoutPython = [
    sagelib
    pygments
    ipython_5
    traitlets
    enum34
    ipython_genutils
    decorator
    pexpect
    ptyprocess
    backports_shutil_get_terminal_size
    pathlib2
    pickleshare
    prompt_toolkit
    wcwidth
    simplegeneric
    openblasCompat
    openblas-blas-pc
    openblas-cblas-pc
    openblas-lapack-pc
    pkgconfig
    psutil
    future
    singular
    sympy
    mpmath
    fpylll
    libgap
    gap
    matplotlib
    scipy
    pyparsing
    cycler
    networkx
    dateutil
    conway_polynomials
    graphs
    ecl
    pillow
    twisted
    cvxopt
    ipykernel
    ipywidgets
    rpy2
    sphinx
    sagenb
    docutils
    jupyter_client
    flask
    werkzeug
    typing
    pyzmq
    zope_interface
    itsdangerous # flask
    Babel
    flask-babel
    flask-autoindex
    flask-openid
    flask-silk
    pytz # babel
    speaklater # babel
    tornado # ipykernel
    imagesize # sphinx
    requests # sphinx
    palp
    R
    giac
    alabaster
    flask-oldsessions
    three
    tachyon
    jmol
    cddlib
    glpk
    pari
    gmp
    sympow
    gfan
    sqlite
    maxima-ecl
    rubiks
    snowballstemmer # needed for doc build
    flint
  ];

  buildInputs = buildInputsWithoutPython ++ [
    (python3.withPackages (ps: with ps; buildInputsWithoutPython ))
    # (python2.withPackages (ps: with ps; buildInputsWithoutPython ))
    python2
  ];

  autoreconfPhase = "true";

  # environment variables for the build
  SAGE_ROOT = sage-src;
  SAGE_LOCAL = sage-src + "/src";
  SAGE_SHARE = sagelib + "/share";
  SAGE_DOC = (placeholder "out") + "/share/doc/sage";
  SAGE_DOC_SRC = (placeholder "out") + "/docsrc";
  SAGE_DOC_MATHJAX = "yes";
  MAKE = "make";

  SINGULARPATH="${singular}/share/singular";
  SINGULAR_SO="${singular}/lib/libSingular.so";
  SINGULAR_EXECUTABLE="${singular}/bin/Singular";
  MAXIMA_FAS="${maxima-ecl}/lib/maxima/${maxima-ecl.version}/binary-ecl/maxima.fas";
  MAXIMA_PREFIX="${maxima-ecl}";
  CONWAY_POLYNOMIALS_DATA_DIR="${conway_polynomials}/share/conway_polynomials";
  GRAPHS_DATA_DIR="${graphs}/share/graphs";
  ELLCURVE_DATA_DIR="${elliptic_curves}/share/ellcurves";
  POLYTOPE_DATA_DIR="${polytopes_db}/share/reflexive_polytopes";
  GAP_ROOT_DIR="${gap}/share/gap/build-dir";
  COMBINATORIAL_DESIGN_DIR="${combinatorial_designs}/share";
  ELLIPTIC_CURVES_DIR="${elliptic_curves}";
  JMOL_DIR="${jmol}";
  PARI_DATA_DIR="${pari_data}/share/pari";

  ECLDIR="${ecl}/lib/ecl-${ecl.version}/";

  unpackPhase = "true";

  buildPhase = ''
    export LD_LIBRARY_PATH="${flint}/lib"
    export DYLD_LIBRARY_PATH="${flint}/lib" # FIXME
    # needed for cython
    export CC='${gcc}/bin/gcc'
    export LDFLAGS='$NIX_TARGET_LDFLAGS -L${sagelib}/lib -L${sagelib}/lib -Wl,-rpath,${sagelib}/lib' # TODO sage paths neeed?

    export CFLAGS='$NIX_CFLAGS_COMPILE'
    export SITE_PACKAGES='${sagelib}/lib/python2.7/site-packages'

    export SAGE_EXTCODE='${src}/src/ext'

    mkdir -p "${SAGE_DOC}"
    cp -r "${src}/src/doc" "${SAGE_DOC_SRC}"
    chmod -R 755 "${SAGE_DOC_SRC}"
    export SAGE_NUM_THREADS="$NIX_BUILD_CORES" # TODO unify environment vars
    HOME="$TMP/sage_home" python -m "sage_setup.docbuild" all html
  '';

  installPhase = "true";
}
