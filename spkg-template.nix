{{pkgs, fetchFromGitHub, fetchurl{spkg_deps} }}:
pkgs.stdenv.mkDerivation rec {{
  version = "{version}";
  name = "{name}-${{version}}";

  src = fetchurl {{
    url = "{download_url}";
    sha1 = "{sha1}";
  }};

  sage-src = fetchFromGitHub {{
    owner = "sagemath";
    repo = "sage";
    rev = "8.1";
    sha256 = "035qvag43bmcwr9yq4qywx7pphzldlb6a0bwldr01qbgv3ny5j40";
  }};

  patches = [{patches}];

  buildInputs = [{build_inputs} ];
  propagatedBuildInputs = buildInputs;
  nativeBuildInputs = buildInputs; # TODO figure out why this is necessary (for openblas and gfortran)

  hardeningDisable = [ "format" ]; # TODO palp

  sourceRoot = "."; # don't cd into the directory after unpack

  preUnpack = ''
      mkdir tmp
      cd tmp
  '';

  postUnpack = ''
    cd ..
    mv tmp/* src
    rm -r tmp

    cp -r ${{sage-src}}/build/pkgs/{name} src/spkg-scripts
    chmod -R 777 src/spkg-scripts

    cp -r ${{sage-src}}/build/bin build-scripts
    chmod -R 777 build-scripts
    echo -n 'python "$@"' > build-scripts/sage-python23
    export PATH="$PWD/build-scripts":"$PATH"

    cd src
  '';


  postPatch = ''
    cd ..
    mv src/spkg-scripts/* .
    rmdir src/spkg-scripts{postPatch}
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
    mkdir -p $out/{{share,bin,include,lib}}
    source ${{sage-src}}/src/bin/sage-dist-helpers

    if [ -f "spkg-build" ]; then
      ${{stdenv.shell}} ./spkg-build
    fi
  '';

  installPhase = ''
    ${{stdenv.shell}} ./spkg-install
  '';

  postInstall = ''
    rm -f "$SAGE_LOCAL"/lib/*.la
  '';

  checkPhase = ''
    [ -f spkg-check ] && ./spkg-check
  '';
}}
