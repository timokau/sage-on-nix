let
  nixpkgs = import <nixpkgs> {};
in
  rec {
    openblas-blas-pc = nixpkgs.callPackage ./openblas-pc.nix { name = "blas"; };
    openblas-cblas-pc = nixpkgs.callPackage ./openblas-pc.nix { name = "cblas"; };
    openblas-lapack-pc = nixpkgs.callPackage ./openblas-pc.nix { name = "lapack"; };
    sagelib = nixpkgs.python2.pkgs.callPackage ./sagelib.nix {
      inherit flint ecl pari glpk numpy;
      inherit sage-src openblas-blas-pc openblas-cblas-pc openblas-lapack-pc;
      pynac = nixpkgs.pynac; # not the python package
      linbox = nixpkgs.linbox.override { withSage = true; };
      cypari2 = nixpkgs.python2Packages.cypari2.override { inherit pari; };
      eclib = nixpkgs.eclib.override { inherit pari; };
      arb = nixpkgs.arb.overrideDerivation (attrs: rec {
        version = "2.11.1";
        src = nixpkgs.fetchFromGitHub {
          owner = "fredrik-johansson";
          repo = "${attrs.pname}";
          rev = "${version}";
          sha256 = "0p0gq8gysg6z4jyjrl0bcl90cwpf4lmmpqblkc3vf36iqvwxk69i";
        };
      });
      symmetrica = nixpkgs.symmetrica.overrideDerivation (attrs: {
        patches = (attrs.patches or []) ++ [
        # TODO figure out which patches are actually necessary
        (nixpkgs.fetchpatch {
          url = "https://git.sagemath.org/sage.git/plain/build/pkgs/symmetrica/patches/de.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
          sha256 = "0df0vqixcfpzny6dkhyj87h8aznz3xn3zfwwlj8pd10bpb90k6gb";
        })
        (nixpkgs.fetchpatch {
          url = "https://git.sagemath.org/sage.git/plain/build/pkgs/symmetrica/patches/int32.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
          sha256 = "0p33c85ck4kd453z687ni4bdcqr1pqx2756j7aq11bf63vjz4cyz";
        })
        (nixpkgs.fetchpatch {
          url = "https://git.sagemath.org/sage.git/plain/build/pkgs/symmetrica/patches/return_values.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
          sha256 = "0dmczkicwl50sivc07w3wm3jpfk78wm576dr25999jdj2ipsb7nk";
        })
        (nixpkgs.fetchpatch {
          url = "https://git.sagemath.org/sage.git/plain/build/pkgs/symmetrica/patches/sort_sum_rename.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
          sha256 = "07lrdwl18nl3xmsasam8jnwjhyypz14259j21vjky023a6qq1lpk";
        })
      ];
    });
    };
    sagenb = nixpkgs.python2.pkgs.callPackage ./sagenb.nix {
      inherit flask-babel;
      mathjax = nixpkgs.nodePackages_8_x.mathjax;
    };
    sagedoc = nixpkgs.python2.pkgs.callPackage ./sagedoc.nix {
      inherit flint palp networkx pari_data ecl pari scipy glpk cvxopt sympy matplotlib flask-babel gfan maxima-ecl;
      inherit sage-src sagenb sagelib openblas-blas-pc openblas-cblas-pc openblas-lapack-pc;
      three = nixpkgs.nodePackages_8_x.three;
    };
    sage = nixpkgs.python.pkgs.callPackage ./sage.nix {
      buildDoc = false;
      inherit networkx pari_data ecl pari scipy glpk gfan cvxopt sympy matplotlib palp maxima-ecl;
      inherit sage-src sagelib sagedoc sagenb openblas-blas-pc openblas-cblas-pc openblas-lapack-pc;
      three = nixpkgs.nodePackages_8_x.three;
      mathjax = nixpkgs.nodePackages_8_x.mathjax;
      r = nixpkgs.rWrapper.override {
        packages = with nixpkgs.rPackages; [ # TODO add standard collection to nixpkgs (https://stat.ethz.ch/R-manual/R-devel/doc/html/packages.html)
          boot
          class
          cluster
          codetools
          foreign
          KernSmooth
          lattice
          MASS
          Matrix
          mgcv
          nlme
          nnet
          rpart
          spatial
          survival
        ];
      };
    };
    sage-src = nixpkgs.callPackage ./sage-src.nix {};

    flint = nixpkgs.flint.override { withBlas = false; };
    palp = nixpkgs.symlinkJoin {
      name = "palp";
      paths = [
        (nixpkgs.palp.override { dimensions = 4; doSymlink = false; })
        (nixpkgs.palp.override { dimensions = 5; doSymlink = false; })
        (nixpkgs.palp.override { dimensions = 6; doSymlink = true; })
        (nixpkgs.palp.override { dimensions = 11; doSymlink = false; })
      ];
    };
    maxima-ecl = nixpkgs.maxima-ecl.override { inherit ecl; };
    networkx = nixpkgs.python2Packages.networkx.overridePythonAttrs (attrs: rec {
      # Does not work with networkx 2.x yet -- see https://trac.sagemath.org/ticket/24374
      version = "1.11";
      src = attrs.src.override {
        inherit version;
        sha256 = "03kplp3z0c7bff8w1qziqqzqz8s5an55j6sfd6dlgdz6bx6i9q5k";
      };
    });
    pari_data = nixpkgs.symlinkJoin {
      name = "pari_data";
      paths = [
        nixpkgs.pari-galdata
        nixpkgs.pari-seadata-small
      ];
    };
    # 16.1.3 not working yet: https://trac.sagemath.org/ticket/22191
    ecl = nixpkgs.ecl_16_1_2.override { threadSupport = false; };
    pari = (nixpkgs.pari.override { withThread = false; }).overrideDerivation (attrs: rec {
      version = "2.10-1280-g88fb5b3";
      src = nixpkgs.fetchurl {
        url = "ftp://ftp.fu-berlin.de/unix/misc/sage/spkg/upstream/pari/pari-${version}.tar.gz";
        sha256 = "19gbsm8jqq3hraanbmsvzkbh88iwlqbckzbnga3y76r7k42akn7m";
      };
      configureFlags = attrs.configureFlags ++ [ # TODO necessary?
        "--kernel=gmp"
      ];
    });
    numpy = nixpkgs.python2Packages.numpy.overridePythonAttrs (attrs: rec {
      # Consider all PEP3141 numbers as scalars (merged upstream in 1.14.2)
      patches = [
        (nixpkgs.fetchpatch {
        url = "https://git.sagemath.org/sage.git/plain/build/pkgs/numpy/patches/PEP_3141.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
        sha256 = "16df7x3av9m5in7pb4lfmh8a1s04ijgphjfw0slajpbzmf9lf8gm";
        })
      ];
      version = "1.13.3";
      src = attrs.src.override {
        inherit version;
        sha256 = "0l576ngjbpjdkyja6jd16znxyjshsn9ky1rscji4zg5smpaqdvin";
      };
    });
    scipy = (nixpkgs.python2Packages.scipy.override { inherit numpy; }).overridePythonAttrs (attrs: rec {
      version = "0.19.1";
      src = attrs.src.override {
        inherit version;
        sha256 = "1rl411bvla6q7qfdb47fpdnyjhfgzl6smpha33n9ar1klykjr6m1";
      };
    });
    glpk = nixpkgs.glpk.overrideDerivation (attrs: rec {
      version = "4.63";
      name = "glpk-${version}";
      src = nixpkgs.fetchurl {
        url = "mirror://gnu/glpk/${name}.tar.gz";
        sha256 = "1xp7nclmp8inp20968bvvfcwmz3mz03sbm0v3yjz8aqwlpqjfkci";
      };
      patches = (attrs.patches or []) ++ [
        # TODO add a fetchDebianPatch?
        # Alternatively patch sage with debians "dt-version-glpk-4.60-extra-hacky-fixes.patch"
        # was rejected upstream, see  https://trac.sagemath.org/ticket/20710#comment:18
        (nixpkgs.fetchpatch {
          url = "https://git.sagemath.org/sage.git/plain/build/pkgs/glpk/patches/error_recovery.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
          sha256 = "0z99z9gd31apb6x5n5n26411qzx0ma3s6dnznc4x61x86bhq31qf";
        })
        (nixpkgs.fetchpatch {
          url = "https://git.sagemath.org/sage.git/plain/build/pkgs/glpk/patches/glp_exact_verbosity.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
          sha256 = "15gm5i2alqla3m463i1qq6jx6c0ns6lip7njvbhp37pgxg4s9hx8";
        })
      ];
    });
    # 0.6 introduces (I think mostly minor formatting) failures
    gfan = nixpkgs.gfan.overrideDerivation (attrs: rec {
      name = "gfan-${version}";
      version = "0.5";
      src = nixpkgs.fetchurl {
        url = "http://home.math.au.dk/jensen/software/gfan/gfan${version}.tar.gz";
        sha256 = "0adk9pia683wf6kn6h1i02b3801jz8zn67yf39pl57md7bqbrsma";
      };
      patches = [
        (nixpkgs.fetchpatch {
          url = "https://git.sagemath.org/sage.git/plain/build/pkgs/gfan/patches/gfan-0.5-gcc6.1-compat.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
          sha256 = "0iq432hqmj72p0m4alim7bm5g6di2drby55p7spi5375cc58fswg";
        })
        (nixpkgs.fetchpatch {
          url = "https://git.sagemath.org/sage.git/plain/build/pkgs/gfan/patches/app_minkowski.cpp.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
          sha256 = "1m9hgqshb4v40np8l0lz5saq02g1bav3g5jrm2yrf3ffgf9z310r";
        })
      ];
    });
    cvxopt = nixpkgs.python2Packages.cvxopt.override { inherit glpk; };
    sympy = nixpkgs.python2Packages.sympy.overridePythonAttrs (attrs: rec {
      # see https://trac.sagemath.org/ticket/20204
      # re-evaluate once a sympy version with https://github.com/sympy/sympy/pull/12826
      # has landed (presumably the next sympy version after 1.11)
      patches = [
        (nixpkgs.fetchpatch {
        url = "https://git.sagemath.org/sage.git/plain/build/pkgs/sympy/patches/03_undeffun_sage.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
        sha256 = "1mh2va1rlgizgvx8yzqwgvbf5wvswarn511002b361mc8yy0bnhr";
        })
      ];
    });
    matplotlib = nixpkgs.python2Packages.matplotlib.override { inherit numpy; };
    flask-babel = nixpkgs.python2Packages.flask-babel.overridePythonAttrs (attrs: rec {
      # for sagenb, no upstream solution yet https://github.com/sagemath/sagenb/issues/437
      version = "0.9";
      src = attrs.src.override {
        inherit version;
        sha256 = "0k7vk4k54y55ma0nx2k5s0phfqbriwslhy5shh3b0d046q7ibzaa";
      };
      doCheck = false;
    });
  }
