{ pkgs
, stdenv
, lib
, makeWrapper
, fetchpatch
, sage-src
, sagelib
, sagedoc
, pygments
, ipython
, traitlets
, cysignals
, pexpect
, ptyprocess
, openblasCompat
, openblas-blas-pc
, openblas-cblas-pc
, openblas-lapack-pc
, pkg-config
, psutil
, future
, singular
, sympy
, fpylll
, libgap
, gap
, matplotlib
, scipy
, pyparsing
, networkx
, conway_polynomials
, graphs
, ecl
, twisted
, service-identity
, cvxopt
, ipykernel
, ipywidgets
, rpy2
, sphinx
, sagenb
, docutils
, typing
, pytz
, tornado
, imagesize
, requests
, gcc
, palp
, r
, giac
, polytopes_db
, combinatorial_designs
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
, nauty
, less
, ppl
, flintqs
, mathjax
, lcalc
, eclib
, gsl
, ntl
, ecm
, zlib
, gfortran
, flint
, pillow
, pynac
, buildDoc ? true
}:

let
  pythonRuntimeDeps = [
    sagelib
    sagenb
    service-identity
    pygments
    ipython
    traitlets
    pexpect
    ptyprocess
    psutil
    future
    sympy
    fpylll
    matplotlib
    scipy
    pyparsing
    networkx
    twisted
    cvxopt
    ipykernel
    ipywidgets
    rpy2
    sphinx
    docutils
    typing
    pillow
  ];

  buildInputs = [
    # !order is important! (python2 should show up first in PATH)
    pythonEnv
    python3
    pynac # FIXME why necessary?
    makeWrapper
    openblasCompat
    openblas-blas-pc
    openblas-cblas-pc
    openblas-lapack-pc
    singular
    libgap
    gap
    pkg-config
    conway_polynomials
    graphs
    ecl
    palp
    r
    giac
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
    nauty
    less
    flintqs
    lcalc
    eclib
    gsl
    ntl
    ecm
    zlib
    gfortran
    ppl
    flint
    # listed explicitly in addition to being propagated by sagelib so that it shows up in CFLAGS
    # FIXME set cflags explicitly
    pynac
  ];

  pythonEnv = python2.buildEnv.override {
    extraLibs = pythonRuntimeDeps;
    ignoreCollisions = true;
  };


  # remove python prefix, replace "-" in the name by "_", apply patch_names
  # python2.7-some-pkg-1.0 -> some_pkg-1.0
  pkg_to_spkg_name = pkg: patch_names: let
    parts = lib.splitString "-" pkg.name;
    # remove python2.7-
    stripped_parts = if (builtins.head parts) == python2.libPrefix then builtins.tail parts else parts;
    version = lib.last stripped_parts;
    orig_pkgname = lib.init stripped_parts;
    pkgname = patch_names (lib.concatStringsSep "_" orig_pkgname);
  in pkgname + "-" + version;


  # return the names of all dependencies in the transitive closure
  transitiveClosure = dep:
  if isNull dep then
    # propagatedBuildInputs might contain null
    # (although that might be considered a programming error in the derivation)
    []
  else
    [ dep ] ++ (
      if builtins.hasAttr "propagatedBuildInputs" dep then
        lib.unique (builtins.concatLists (map transitiveClosure dep.propagatedBuildInputs))
      else
      []
    );

  allInputs = lib.remove null (buildInputs ++ pythonRuntimeDeps);
  transitiveDeps = lib.unique (builtins.concatLists (map transitiveClosure allInputs ));
  # fix differences between spkg and sage names
  # (could patch sage instead, but this is more lightweight and also works for packages depending on sage)
  patch_names = builtins.replaceStrings [
    "zope.interface"
    "node_three"
  ] [
    "zope_interface"
    "threejs"
  ];
  # spkg names (this_is_a_package-version) of all transitive deps
  input_names = map (dep: pkg_to_spkg_name dep patch_names) transitiveDeps;
in
stdenv.mkDerivation rec {
  version = "8.1"; # TODO
  name = "sage-${version}";

  inherit buildInputs pythonEnv; # FIXME

  src = sage-src;

  nativeBuildInputs = buildInputs; # TODO

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

    for pkg in ${lib.concatStringsSep " " input_names}; do
      touch "$out/var/lib/sage/installed/$pkg"
    done

    cp -r src/bin $out/bin
    cp -r build/bin $out/build-bin
    # TODO ugly hack to have python2 and python3 mix
    # Better to use python.withPackages instead
    makeWrapper "${python3}/bin/python3" "$out/bin/python3" --unset PYTHONHOME
    mv $out/bin/sage-env{,-orig}
    touch $out/bin/sage-arch-env
    echo """
      export PKG_CONFIG_PATH='$PKG_CONFIG_PATH' # TODO needed for tests, truly needed at runtime?
      export SAGE_ROOT='${SAGE_ROOT}'
      export SAGE_LOCAL='${SAGE_LOCAL}'
      export SAGE_SHARE='${SAGE_SHARE}'
      export SAGE_SCRIPTS_DIR='${placeholder "out"}/bin'
      export PATH='$out/bin:$out/build-bin:$PATH' # TODO prefix

      . "$out/bin/sage-env-orig"

      export PATH='$out/bin:$out/build-bin:$PATH' # reset path changed in sage-env-orig
      export SAGE_LOGS=\"\''${TMP:-/tmp}/sage-logs\"
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
      export MAXIMA_FAS='${maxima-ecl}/lib/maxima/${maxima-ecl.version}/binary-ecl/maxima.fas'
      export MAXIMA_PREFIX="${maxima-ecl}"
      export CONWAY_POLYNOMIALS_DATA_DIR='${conway_polynomials}/share/conway_polynomials'
      export GRAPHS_DATA_DIR='${graphs}/share/graphs'
      export ELLCURVE_DATA_DIR='${elliptic_curves}/share/ellcurves' # TODO unify
      export POLYTOPE_DATA_DIR='${polytopes_db}/share/reflexive_polytopes'
      export GAP_ROOT_DIR='${gap}/share/gap/build-dir'
      export THEBE_DIR='$\{thebe}/share/thebe'

      export ECLDIR='${ecl}/lib/ecl-${ecl.version}/'
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
      export MATHJAX_DIR="${mathjax}/lib/node_modules/mathjax"
      export MATRIX_GF2E_DENSE_DIR="$\{matrix_gf2e_dense}"
      export MATRIX_MOD2_DENSE_DIR="$\{matrix_mod2_dense}"
      export ODLYZKO_DIR="$\{odlyzko}"
      export PBORI_DIR="$\{pbori}"
      export SLOANE_DIR="$\{sloane}"
      export STEIN_WATKINS_DIR="$\{stein_watkins}"
      export SYMBOLIC_DATA_DIR="$\{symbolic_data}"
      export THREEJS_DIR="${three}/lib/node_modules/three"
      export CYSIGNALS_INCLUDE="${cysignals}/lib/python2.7/site-packages"

      # for find_library
      export DYLD_LIBRARY_PATH="${lib.makeLibraryPath [stdenv.cc.libc singular]}:\$DYLD_LIBRARY_PATH"
    """ >> $out/bin/sage-env

    substituteInPlace $out/bin/sage-env-orig \
        --replace '[ ! -f "$SAGE_SCRIPTS_DIR/sage-env-config" ]' 'false' \
        --replace '. "$SAGE_SCRIPTS_DIR/sage-env-config"' '# Nothing'

    patchShebangs "$out" # done here in addition to fixup for the tests
  '';

  doCheck = true;
  checkPhase = ''
    sagehome="$TMP/sage-home"
    mkdir -p "$sagehome"

    # `env -i` because otherwise gcc gets overwhelmed by long LDFLAG lists etc.
    env -i \
      HOME="$sagehome" \
      SHELL="${stdenv.shell}" \
      TMP="$TMP" \
      "$out/bin/sage" -t --nthreads "$NIX_BUILD_CORES" --timeout 0 --exitfirst --all
      # TODO
      #"$out/bin/sage" -t --nthreads "$NIX_BUILD_CORES" --timeout 0 --only-errors --exitfirst --long --all
  '';
  # TODO optionally enable sagedoc tests
}
