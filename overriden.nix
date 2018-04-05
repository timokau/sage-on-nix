let
  newpkgs = spkgs (newpkgs // overrides);
  spkgs = import ./all.nix;
  nixpkgs = import <nixpkgs> {};
  overrides = rec {
    gcc = nixpkgs.gcc;
    gfortran = nixpkgs.gfortran6;
    cliquer = nixpkgs.cliquer;
    babel = nixpkgs.python2Packages.Babel;
    backports_shutil_get_terminal_size = nixpkgs.python2Packages.backports_shutil_get_terminal_size;
    pkgconf = nixpkgs.pkgconfig;
    pkgconfig = nixpkgs.python2Packages.pkgconfig;
    m4ri = nixpkgs.m4ri;
    python = nixpkgs.python2;
    threejs = nixpkgs.nodePackages_8_x.three;
    mathjax = nixpkgs.nodePackages_8_x.mathjax;
    pathlib2 = nixpkgs.python2Packages.pathlib2;
    python2 = nixpkgs.python2;
    ipywidgets = nixpkgs.python2Packages.ipywidgets;
    python3 = nixpkgs.python3;
    boost_cropped = nixpkgs.boost;
    zn_poly = nixpkgs.zn_poly;
    flint = nixpkgs.flint.override { withBlas = false; };
    flintqs = nixpkgs.flintqs;
    setuptools = nixpkgs.python2Packages.setuptools;
    pip = nixpkgs.python2Packages.pip;
    libgd = nixpkgs.gd; # TODO check why sages gd doesn't provide Png functionality
    brial = nixpkgs.brial;
    palp = nixpkgs.symlinkJoin {
      name = "palp";
      paths = [
        (nixpkgs.palp.override { dimensions = 4; doSymlink = false; })
        (nixpkgs.palp.override { dimensions = 5; doSymlink = false; })
        (nixpkgs.palp.override { dimensions = 6; doSymlink = true; })
        (nixpkgs.palp.override { dimensions = 11; doSymlink = false; })
      ];
    };
    buildPythonPackage = nixpkgs.python2Packages.buildPythonPackage;
    pillow = nixpkgs.python2Packages.pillow;
    rpy2 = nixpkgs.python2Packages.rpy2;
    ntl = nixpkgs.ntl;
    iml = nixpkgs.iml;
    mpc = nixpkgs.libmpc;
    mpfi = nixpkgs.mpfi;
    maxima = nixpkgs.maxima-ecl.override {
      inherit ecl;
    };
    zlib = nixpkgs.zlib;
    sqlite = nixpkgs.sqlite;
    jmol = nixpkgs.jmol;
    docutils = nixpkgs.python2Packages.docutils;
    simplegeneric = nixpkgs.python2Packages.simplegeneric;
    gc = nixpkgs.boehmgc;
    ipython_genutils = nixpkgs.python2Packages.ipython_genutils;
    tornado = nixpkgs.python2Packages.tornado;
    decorator = nixpkgs.python2Packages.decorator;
    markupsafe = nixpkgs.python2Packages.markupsafe;
    pytz = nixpkgs.python2Packages.pytz;
    nauty = nixpkgs.nauty;
    networkx = nixpkgs.python2Packages.networkx.overridePythonAttrs (attrs: rec {
      # Does not work with networkx 2.x yet -- see https://trac.sagemath.org/ticket/24374
      version = "1.11";
      src = attrs.src.override {
        inherit version;
        sha256 = "03kplp3z0c7bff8w1qziqqzqz8s5an55j6sfd6dlgdz6bx6i9q5k";
      };
    });

    distutils = nixpkgs.python2Packages.distutils;
    cython = nixpkgs.python2Packages.cython;
    cysignals = nixpkgs.python2Packages.cysignals;
    readline = nixpkgs.readline;
    libpng = nixpkgs.libpng;
    m4rie = nixpkgs.m4rie;

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
    ecm = nixpkgs.ecm;
    jupyter_client = nixpkgs.python2Packages.jupyter_client;
    jupyter_core = nixpkgs.python2Packages.jupyter_core;
    twisted = nixpkgs.python2Packages.twisted; # with service-identity
    service-identity = nixpkgs.python2Packages.service-identity;
    pexpect = nixpkgs.python2Packages.pexpect;
    ptyprocess = nixpkgs.python2Packages.ptyprocess;

    openblas-blas-pc = newpkgs.callPackage ./openblas-pc.nix { name = "blas"; };
    openblas-cblas-pc = newpkgs.callPackage ./openblas-pc.nix { name = "cblas"; };
    openblas-lapack-pc = newpkgs.callPackage ./openblas-pc.nix { name = "lapack"; };
    sagelib = newpkgs.callPackage ./sagelib.nix {};
    sagenb = newpkgs.callPackage ./sagenb.nix {};
    sagedoc = newpkgs.callPackage ./sagedoc.nix {};
    sage = newpkgs.callPackage ./sage.nix { buildDoc = false; };
    combinatorial_designs = nixpkgs.combinatorial_designs;
    conway_polynomials = nixpkgs.conway_polynomials;
    elliptic_curves = nixpkgs.elliptic_curves;
    graphs = nixpkgs.graphs;
    pari_data = nixpkgs.symlinkJoin {
      name = "pari_data";
      paths = [
        nixpkgs.pari-galdata
        nixpkgs.pari-seadata-small
      ];
    };
    polytopes_db = nixpkgs.polytopes_db;
    sage-src = newpkgs.callPackage ./sage-src.nix {};

    pickleshare = nixpkgs.python2Packages.pickleshare;
    givaro = nixpkgs.givaro;
    six = nixpkgs.python2Packages.six;
    fflas_ffpack = nixpkgs.fflas-ffpack;
    linbox = nixpkgs.linbox.override { withSage = true; };
    imagesize = nixpkgs.python2Packages.imagesize;
    ipykernel = nixpkgs.python2Packages.ipykernel;
    dateutil = nixpkgs.python2Packages.dateutil;
    # 16.1.3 not working yet: https://trac.sagemath.org/ticket/22191
    ecl = nixpkgs.ecl_16_1_2.override { threadSupport = false; };
    wcwidth = nixpkgs.python2Packages.wcwidth;
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
    giac = nixpkgs.giac;
    pynac = nixpkgs.pynac;
    ipython = nixpkgs.python2Packages.ipython_5;
    pathlib = nixpkgs.python2Packages.pathlib;
    scipy = (nixpkgs.python2Packages.scipy.override { inherit numpy; }).overridePythonAttrs (attrs: rec {
      version = "0.19.1";
      src = attrs.src.override {
        inherit version;
        sha256 = "1rl411bvla6q7qfdb47fpdnyjhfgzl6smpha33n9ar1klykjr6m1";
      };
    });
    itsdangerous = nixpkgs.python2Packages.itsdangerous;
    enum34 = nixpkgs.python2Packages.enum34;
    werkzeug = nixpkgs.python2Packages.werkzeug;
    tachyon = nixpkgs.tachyon;
    snowballstemmer = nixpkgs.python2Packages.snowballstemmer;
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
    gsl = nixpkgs.gsl;
    jinja2 = nixpkgs.python2Packages.jinja2;
    future = nixpkgs.python2Packages.future;
    psutil = nixpkgs.python2Packages.psutil;
    eclib = nixpkgs.eclib.override { inherit pari; };
    pyparsing = nixpkgs.python2Packages.pyparsing;
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
    cddlib = nixpkgs.cddlib;
    singular = nixpkgs.singular;
    openblas = nixpkgs.openblasCompat;
    ratpoints = nixpkgs.ratpoints;
    alabaster = nixpkgs.python2Packages.alabaster;
    pygments = nixpkgs.python2Packages.pygments;
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
    arb = nixpkgs.arb.overrideDerivation (attrs: rec {
      version = "2.11.1";
      src = nixpkgs.fetchFromGitHub {
        owner = "fredrik-johansson";
        repo = "${attrs.pname}";
        rev = "${version}";
        sha256 = "0p0gq8gysg6z4jyjrl0bcl90cwpf4lmmpqblkc3vf36iqvwxk69i";
      };
    });
    matplotlib = nixpkgs.python2Packages.matplotlib.override { inherit numpy; };
    speaklater = nixpkgs.python2Packages.speaklater;
    libgap = nixpkgs.libgap;
    ppl = nixpkgs.ppl;
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
    cycler = nixpkgs.python2Packages.cycler;
    python_openid = nixpkgs.python2Packages.python-openid;
    flask = nixpkgs.python2Packages.flask;
    flask_autoindex = nixpkgs.python2Packages.flask-autoindex;
    flask_babel = nixpkgs.python2Packages.flask-babel.overridePythonAttrs (attrs: rec {
      # for sagenb, no upstream solution yet https://github.com/sagemath/sagenb/issues/437
      version = "0.9";
      src = attrs.src.override {
        inherit version;
        sha256 = "0k7vk4k54y55ma0nx2k5s0phfqbriwslhy5shh3b0d046q7ibzaa";
      };
      doCheck = false;
    });
    flask_oldsessions = nixpkgs.python2Packages.flask-oldsessions;
    flask_openid = nixpkgs.python2Packages.flask-openid;
    flask_silk = nixpkgs.python2Packages.flask-silk;
    traitlets = nixpkgs.python2Packages.traitlets;
    pyzmq = nixpkgs.python2Packages.pyzmq;
    requests = nixpkgs.python2Packages.requests;
    typing = nixpkgs.python2Packages.typing;
    sphinx = nixpkgs.python2Packages.sphinx;
    mpmath = nixpkgs.python2Packages.mpmath;
    gap = nixpkgs.gap;
    zope_interface = nixpkgs.python2Packages.zope_interface;
    mpfr = nixpkgs.mpfr;
    fplll = nixpkgs.fplll;
    fpylll = nixpkgs.python2Packages.fpylll;
  };
in
  newpkgs // overrides
