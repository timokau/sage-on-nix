{ pkgs
, stdenv
, makeWrapper
, sage-src
, sagelib
, sagedoc
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
, service-identity # for twisted
, cvxopt
, ipykernel
, ipywidgets
, rpy2
, sphinx
, sagenb
, docutils
, jupyter_client
, flask
, flask_babel
, flask_oldsessions
, flask_autoindex
, flask_openid
, flask_silk
, werkzeug # for notebook
, typing
, pyzmq
, zope_interface # for twisted
, itsdangerous # flask
, babel # sphinx
, pytz
, speaklater # sagenb
, tornado
, imagesize
, requests
, gcc
, palp
, r
, giac
, polytopes_db
, combinatorial_designs
, alabaster
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
, python2
, rubiks
, snowballstemmer
, nauty
, less
, ppl
, python_openid
, flintqs
, cysignals
, mathjax
, buildDoc ? true
}:
stdenv.mkDerivation rec {
  version = "8.1"; # TODO
  name = "sage-${version}";

  src = sage-src;

  buildInputsWithoutPython = [
    sagelib
    makeWrapper
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
    service-identity
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
    flask_autoindex
    flask_openid
    flask_silk
    pytz # babel
    speaklater # babel
    tornado # ipykernel
    imagesize # sphinx
    requests # sphinx
    palp
    r
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
    maxima
    rubiks
    snowballstemmer # needed for doc build
    nauty
    less
    python_openid
    flintqs
    cysignals
  ];

  buildInputs = buildInputsWithoutPython ++ [
    (python3.withPackages (ps: with ps; buildInputsWithoutPython ))
    # (python2.withPackages (ps: with ps; buildInputsWithoutPython ))
    python2
  ];

  nativeBuildInputs = buildInputs; # TODO

  installed_packages = stdenv.lib.concatStringsSep " " (map (pkg: pkg.sage-namestring or pkg.name) (buildInputs ++ sagelib.buildInputs));

  configurePhase = ''
    # NOOP
  '';

  # environment variables for the build
  SAGE_ROOT = src; # TODO
  SAGE_LOCAL = placeholder "out";
  SAGE_SHARE = sagelib + "/share";
  SAGE_DOC = if buildDoc then (sagedoc + "/share/doc/sage") else (SAGE_SHARE + "/doc/sage");
  SAGE_DOC_SRC = if buildDoc then (sagedoc + "/docsrc") else (src + "/src/doc");

  installPhase = ''
    #NOOP
  '';

  autoreconfPhase = ''
    #NOOP
  ''; # TODO

  buildPhase = ''
    mkdir -p $out/var/lib/sage/installed

    for pkg in $installed_packages; do
      touch "$out/var/lib/sage/installed/$pkg"
    done

    cp -r src/bin $out/bin
    # TODO ugly hack to have python2 and python3 mix
    # Better to use python.withPackages instead
    makeWrapper "${python3}/bin/python3" "$out/bin/python3" --set PYTHONPATH ""
    mv $out/bin/sage-env{,-orig}
    touch $out/bin/sage-arch-env
    echo """
      export PYTHONPATH='$PYTHONPATH'
      export PKG_CONFIG_PATH='$PKG_CONFIG_PATH' # TODO needed for tests, truly needed at runtime?
      export SAGE_ROOT='${SAGE_ROOT}'
      export SAGE_LOCAL='${SAGE_LOCAL}'
      export SAGE_SHARE='${SAGE_SHARE}'
      export SAGE_SCRIPTS_DIR='${placeholder "out"}/bin'
      export PATH='$out/bin:$PATH'

      . "$out/bin/sage-env-orig"

      export SAGE_LOGS="$TMP/sage-logs"
      export SAGE_DOC='${SAGE_DOC}'
      export SAGE_DOC_SRC='${SAGE_DOC_SRC}'

      export JUPYTER_PATH="\$DOT_SAGE/jupyter"
      mkdir -p "\$JUPYTER_PATH"

      export GP_DATA_DIR="${pari_data}/share/pari"
      export PARI_DATA_DIR="${pari_data}" # TODO
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
      export LDFLAGS='$NIX_TARGET_LDFLAGS -L${sagelib}/lib -L${sagelib}/lib -Wl,-rpath,${sagelib}/lib' # TODO sage paths needed?

      export CFLAGS='$NIX_CFLAGS_COMPILE'
      export SAGE_LIB='${sagelib}/lib/python2.7/site-packages'

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
      export JSMOL_DIR="${jmol}" # TODO duplicate
      export KHOEL_DIR="$\{khoel}"
      export LIE_DIR="$\{lie}"
      export M4RI_DIR="$\{m4ri}"
      export MATHJAX_DIR="${mathjax}"
      export MATRIX_GF2E_DENSE_DIR="$\{matrix_gf2e_dense}"
      export MATRIX_MOD2_DENSE_DIR="$\{matrix_mod2_dense}"
      export ODLYZKO_DIR="$\{odlyzko}"
      export PBORI_DIR="$\{pbori}"
      export SLOANE_DIR="$\{sloane}"
      export STEIN_WATKINS_DIR="$\{stein_watkins}"
      export SYMBOLIC_DATA_DIR="$\{symbolic_data}"
      export THREEJS_DIR="${threejs}"
      export CYSIGNALS_INCLUDE="${cysignals}/lib/python2.7/site-packages"

      # for find_library
      export DYLD_LIBRARY_PATH="${stdenv.lib.makeLibraryPath [stdenv.cc.libc singular]}:\$DYLD_LIBRARY_PATH"
    """ >> $out/bin/sage-env

    substituteInPlace $out/bin/sage-env-orig \
        --replace '[ ! -f "$SAGE_SCRIPTS_DIR/sage-env-config" ]' 'false' \
        --replace '. "$SAGE_SCRIPTS_DIR/sage-env-config"' '# Nothing'
  '';

  doCheck = true;
  checkPhase = ''
    sagehome="$TMP/sage-home"
    mkdir -p "$sagehome"

    # `env -i` because otherwise gcc gets overwhelmed by long LDFLAG lists etc.
    env -i \
      HOME="$sagehome" \
      SHELL="${stdenv.shell}" \
      "$out/bin/sage" -t --nthreads "$NIX_BUILD_CORES" --timeout 0 --exitfirst --long --all
  '';
}
