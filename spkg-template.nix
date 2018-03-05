{{pkgs, sage-src, fetchurl{spkg_deps} }}:
pkgs.stdenv.mkDerivation rec {{
  version = "{version}";
  name = "spkg-${{name-orig}}-${{version}}";
  # used by sage to detect which packages are installed
  name-orig = "{name}";
  patch-version = "{patch_version}";
  sage-namestring = "${{name-orig}}-${{version}}.${{patch-version}}";

  src = fetchurl {{
    url = "{download_url}";
    sha1 = "{sha1}";
  }};

  patches = [{patches}];

  buildInputs = [{build_inputs} ];
  nativeBuildInputs = buildInputs; # TODO figure out why this is necessary (for openblas and gfortran)

  sourceRoot = "."; # don't cd into the directory after unpack

  preUnpack = ''
      mkdir tmp
      cd tmp
  '';

  postUnpack = ''
    cd ..
    mv tmp/* src || mv tmp src # in case unpack hasn't craeted a subdir
    rm -rf tmp

    cp -r ${{sage-src}}/build/pkgs/{name} src/spkg-scripts
    chmod -R 777 src/spkg-scripts

    cp -r ${{sage-src}}/src/bin src-scripts

    export PATH="${{sage-src}}/build/bin":"$PWD/src-scripts":"$PATH"
    export UNAME="$(uname)"
    export SAGE_FAT_BINARY=yes

    cd src
  '';


  postPatch = ''
    cd ..
    mv src/spkg-scripts/* .
    rmdir src/spkg-scripts
{postPatch}
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
  PKG_NAME = "{name}";
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

  # TODO
  # doCheck = true;
  checkPhase = ''
    [ -f spkg-check ] && ./spkg-check
  '';
}}
