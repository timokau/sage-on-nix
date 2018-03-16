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
    # More for the linbox update
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/patch/?id=4c1474a6c04ddfab86c79b2ab6809ebfdfba3d49";
      sha256 = "1nkhdrwqj9bidy57nh2rwhrb1aib8a9ra3rc613prci50883cl35";
    })

    # Patch the giac true symbol to be compatible with giac >= 1.2.3-57 (included in 8.2)
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/patch/?id=9141f652ae719f1db96f33eaa096ad5ab4e545c3";
      sha256 = "0yi2bxl58q2i1i261p9brpgynhf27nq8mh4fk8a25sdvixb36f2v";
    })

    # sphinx 1.6 -> 1.7 upgrade (should be included in 8.2)
    # this is https://git.sagemath.org/sage.git/patch?id=676a1d533bb97c7006651f353a26dd20ab001ae1 stripped of all build/pkgs patches, since those are not applicable to the sage 8.1 source
    ./patches/sagelib/sphinx-1.7.patch

    # Update singular to 4.1.1 (not yet upstreamed, might not land in sage 8.2)
    # See https://groups.google.com/forum/#!topic/sage-packaging/cS3v05Q0zso
    # TODO
    # (fetchpatch {
    #   url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/sagemath-singular-4.1.1.patch?h=packages/sagemath";
    #   sha256 = "1adz6lrpvywqk1aym8pfsvadly8r476a0isyqlpzyg9dpyn2mspa";
    # })

    # Ignore pari stack warnings in doctests (upstream patches pari instead)
    (fetchpatch {
      url = "https://sources.debian.org/data/main/s/sagemath/8.1-7/debian/patches/u2-pari-stackwarn.patch";
      sha256 = "0m8vr5v0lwq0d3iar3qc82wdsw81n0c0qqdifijqbrqiyqskchd1";
      stripLen = 1;
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
