{ pkgs
, fetchFromGitHub
, sagelib
, pygments
, ipython
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
, openblas
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
# , maxima
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
, werkzeug # for notebook
, typing
, pyzmq
, zope_interface # for twisted
, itsdangerous # flask
, babel # sphinx
, flask_babel
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
, flask_oldsessions
, threejs
, tachyon
, jmol
, jdk
, elliptic_curves
, maxima
, cddlib
, glpk
, pari
, pari_data
, gmp
, sympow
, gfan
, sqlite
, python3
}:
pkgs.stdenv.mkDerivation rec {
  version = "8.1"; # TODO
  name = "sage-${version}";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = "8.1";
    sha256 = "035qvag43bmcwr9yq4qywx7pphzldlb6a0bwldr01qbgv3ny5j40";
  };

  buildInputs = [
    sagelib
    pygments
    ipython
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
    openblas
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
    babel
    flask_babel
    pytz # babel
    speaklater # babel
    tornado # ipykernel
    imagesize # sphinx
    requests # sphinx
    palp
    R
    giac
    alabaster
    flask_oldsessions
    threejs
    tachyon
    jmol
    jdk
    cddlib
    glpk
    pari
    gmp
    sympow
    gfan
    sqlite
    python3
  ];

  nativeBuildInputs = buildInputs; # TODO

  configurePhase = ''
    # NOOP
  '';

  # environment variables for the build
  SAGE_ROOT = src;
  SAGE_LOCAL = placeholder "out";
  SAGE_SHARE = sagelib + "/share";

  buildPhase = ''
    #NOOP
  '';

  autoreconfPhase = ''
    #NOOP
  ''; # TODO

  installPhase = ''
    mkdir -p $out
    mkdir -p $out/var/lib/sage/installed # TODO
    cp -r src/bin $out/bin
    mv $out/bin/sage-env{,-orig}
    touch $out/bin/sage-arch-env
    echo """
      export PYTHONPATH='$PYTHONPATH'
      export SAGE_ROOT='${SAGE_ROOT}'
      export SAGE_LOCAL='${SAGE_LOCAL}'
      export SAGE_SHARE='${SAGE_SHARE}'
      export SAGE_SCRIPTS_DIR='${placeholder "out"}/bin'
      export PATH='$out/bin:$PATH'
      . "\$\(dirname "\$0"\)"/sage-env-orig
      export SAGE_LOGS="$TMP/sage-logs"

      export GP_DATA_DIR="${pari_data}/share/pari"
      export GPHELP="${pari}/bin/gphelp"
      export GPDOCDIR="${pari}/share/pari/doc"

      export SINGULARPATH='${singular}/share/singular'
      export SINGULAR_SO='${singular}/lib/libSingular.so'
      export SINGULAR_EXECUTABLE='${singular}/bin/Singular'
      export MAXIMA_FAS='${maxima}/lib/maxima/${maxima.version}/binary-ecl/maxima.fas'
      export MAXIMA_PREFIX="${maxima}"
      export CONWAY_POLYNOMIALS_DATA_DIR='${conway_polynomials}/share/conway_polynomials'
      export GRAPHS_DATA_DIR='${graphs}/share/graphs'
      export ELLCURVE_DATA_DIR='${elliptic_curves}/share/ellcurves' # TODO unify
      export POLYTOPE_DATA_DIR='${polytopes_db}/share/reflexive_polytopes'
      export GAP_ROOT_DIR='${gap}/gap/latest'
      export GAP_DIR='${gap}/gap/latest'
      export THEBE_DIR='$\{thebe}/share/thebe'

      export ECLDIR='${ecl}/lib/ecl/' # TODO necessary?
      # needed for cython
      export CC='${gcc}/bin/gcc'
      export LDFLAGS='$NIX_TARGET_LDFLAGS'
      export CFLAGS='$NIX_CFLAGS_COMPILE'

      export SAGE_EXTCODE='${src}/src/ext'

      # own extensions
      export COMBINATORIAL_DESIGN_DIR="${combinatorial_designs}/share"
      export COEXTER_DIR="$\{coexter}"
      export CPLEX_DIR="$\{cplex}"
      export CSDP_DIR="$\{csdp}"
      export CUNNINGHAM_TABLES_DIR="$\{cunningham_tables}"
      export D3JS_DIR="$\{d3js}"
      export DATABASE_MUTATION_CLASS_DIR="$\{database_mutation_class}"
      export ELLIPTIC_CURVES_DIR="${elliptic_curves}" # TODO
      export CREMONA_ELLCURVE_DIR="" # TODO optional
      export GUROBI_DIR="$\{gubori}"
      export JMOL_DIR="${jmol}"
      export JONES_DIR="$\{jones}"
      export JSMOL_DIR="$\{jsmol}"
      export KHOEL_DIR="$\{khoel}"
      export LIE_DIR="$\{lie}"
      export M4RI_DIR="$\{m4ri}"
      export MATHJAX_DIR="$\{mathjax}"
      export MATRIX_GF2E_DENSE_DIR="$\{matrix_gf2e_dense}"
      export MATRIX_MOD2_DENSE_DIR="$\{matrix_mod2_dense}"
      export ODLYZKO_DIR="$\{odlyzko}"
      export PBORI_DIR="$\{pbori}"
      export SLOANE_DIR="$\{sloane}"
      export STEIN_WATKINS_DIR="$\{stein_watkins}"
      export SYMBOLIC_DATA_DIR="$\{symbolic_data}"
      export THREEJS_DIR="$\{threejs}"
      export PARI_DATA_DIR="${pari_data}/share/pari"
    """ >> $out/bin/sage-env

    substituteInPlace $out/bin/sage-env-orig \
        --replace '[ ! -f "$SAGE_SCRIPTS_DIR/sage-env-config" ]' 'false' \
        --replace '. "$SAGE_SCRIPTS_DIR/sage-env-config"' '# Nothing'
  '';

  # TODO -p
  checkPhase = ''
    DOT_SATE=/tmp/dot_sage $out/bin/sage -t -p --all
  '';
}
