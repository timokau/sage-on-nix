{ pkgs
, fetchFromGitHub
, fetchpatch
, stdenv
, python
}:
pkgs.stdenv.mkDerivation rec {
  version = "8.1"; # TODO
  name = "sage-src-${version}";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = "8.1";
    sha256 = "035qvag43bmcwr9yq4qywx7pphzldlb6a0bwldr01qbgv3ny5j40";
  };

  patches = [
    # Make pkgconfig return lists instead of sets
    ./patches/sagelib/pkgconfig-set.patch
    ./patches/sagelib/spkg-paths.patch
    # FIXME
    ./patches/sagelib/no-jupyter-kernel.patch
    ./patches/sagelib/maxima-absolute-paths.patch
    # Tests in nix unnecessary behaviour
    ./patches/sagelib/disable-refusing-doctests-test.patch
    ./patches/sagelib/remove-python-workarounds.patch
    ./patches/sagelib/doctest-silence-cache-warning.patch
    ./patches/sagelib/python3-syntax-warning-lenient.patch
    ./patches/sagelib/remove-sage-started.patch
    ./patches/sagelib/qepcad-config-optional.patch
    ./patches/sagelib/respect-jupyter-path.patch
    ./patches/sagelib/python-5755-hotpatch.patch
    ./patches/sagelib/add-cysignals-include.patch
    ./patches/sagelib/find_library.patch
    ./patches/sagelib/no-python3-syntax-test.patch
    # FIXME this is a *temporary* fix for the timeout which is caused by PYTHONPATH being slow
    # and adding *significant* (~2s) overhead to python startup
    ./patches/sagelib/increase_timeout.patch
    ./patches/sagelib/doctests_optional.patch
    # Update linbox, fixed in sage-8.2
    # https://git.sagemath.org/sage.git/commit?id=dac963f5985bf6b9c40b1aad619946b5a1f917d7
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/patch/?id=dac963f5985bf6b9c40b1aad619946b5a1f917d7";
      sha256 = "0m8s225p0i8cvj04n0wbk12az6193gf7hp0y3cbnhi47mg99d2xb";
    })
    # More for the  update
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/patch/?id=4c1474a6c04ddfab86c79b2ab6809ebfdfba3d49";
      sha256 = "1nkhdrwqj9bidy57nh2rwhrb1aib8a9ra3rc613prci50883cl35";
    })
  ];

  buildInputs = [
    python # for shebang patching
  ];

  configurePhase = "true";

  buildPhase = "true";

  installPhase = ''
    cp -r . "$out"
  '';
}
