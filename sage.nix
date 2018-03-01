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
, maxima
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
    maxima
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
    export PYTHONPATH="$PYTHONPATH"
    export SAGE_ROOT=${SAGE_ROOT}
    export SAGE_LOCAL=${SAGE_LOCAL}
    export SAGE_SHARE=${SAGE_SHARE}
    export SAGE_SCRIPTS_DIR=${placeholder "out"}/bin
    export PATH="$out/bin:$PATH"
    . "\$\(dirname "\$0"\)"/sage-env-orig
    export SINGULARPATH="${singular}/share/singular"
    export SINGULAR_EXECUTABLE="${singular}/bin/Singular"
    export CONWAY_POLYNOMIALS_DATA_DIR="${conway_polynomials}/share/conway_polynomials"
    export GRAPHS_DATA_DIR="$\{graphs}/share/graphs"
    export ELLCURVE_DATA_DIR="$\{ellcurves}/share/ellcurves"
    export POLYTOPE_DATA_DIR="$\{reflexive_polytopes}/share/reflexive_polytopes"
    export GAP_ROOT_DIR="${gap}/gap/latest"
    export GAP_DIR="${gap}/gap/latest"
    export THEBE_DIR="$\{thebe}/share/thebe"

    """ >> $out/bin/sage-env
    substituteInPlace $out/bin/sage-env-orig \
        --replace '[ ! -f "$SAGE_SCRIPTS_DIR/sage-env-config" ]' 'false' \
        --replace '. "$SAGE_SCRIPTS_DIR/sage-env-config"' '# Nothing'
  '';
}
