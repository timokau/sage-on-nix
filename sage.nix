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
, libgd
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
    libgd
  ];

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

  installPhase = ''
    mkdir -p $out
    cp -r src/bin $out/bin
    mv $out/bin/sage-env{,-orig}
    echo """
    export PYTHONPATH="$PYTHONPATH"
    export SAGE_ROOT=${SAGE_ROOT}
    export SAGE_LOCAL=${SAGE_LOCAL}
    export SAGE_SHARE=${SAGE_SHARE}
    export SAGE_SCRIPTS_DIR=${SAGE_SHARE}/src/bin
    export PATH="$out/bin:$PATH"
    . \$0-env-orig
    """ >> $out/bin/sage-env
    substituteInPlace $out/bin/sage-env-orig \
        --replace '[ ! -f "$SAGE_SCRIPTS_DIR/sage-env-config" ]' 'false' \
        --replace '. "$SAGE_SCRIPTS_DIR/sage-env-config"' '# Nothing'
  '';
}
