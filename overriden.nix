let
  newpkgs = spkgs (newpkgs // overrides);
  spkgs = import ./all.nix;
  nixpkgs = import <nixpkgs> {};
  overrides = rec {
    gcc = nixpkgs.gcc;
    gfortran = nixpkgs.gfortran6;
    pkgconf = nixpkgs.pkgconfig;
    pkgconfig = nixpkgs.python2Packages.pkgconfig;
    python = nixpkgs.python2;
    python2 = nixpkgs.python2;
    python3 = nixpkgs.python3;
    flint = nixpkgs.flint.override { withBlas = false; };
    setuptools = nixpkgs.python2Packages.setuptools;
    pip = nixpkgs.python2Packages.pip;
    libgd = nixpkgs.gd; # TODO check why sages gd doesn't provide Png functionality
    pillow = nixpkgs.python2Packages.pillow;
    ntl = nixpkgs.ntl;
    iml = nixpkgs.iml;
    mpfi = nixpkgs.mpfi;
    zlib = nixpkgs.zlib;
    docutils = nixpkgs.python2Packages.docutils;
    simplegeneric = nixpkgs.python2Packages.simplegeneric;
    gc = nixpkgs.boehmgc;
    ipython_genutils = nixpkgs.python2Packages.ipython_genutils;
    tornado = nixpkgs.python2Packages.tornado;
    decorator = nixpkgs.python2Packages.decorator;
    markupsafe = nixpkgs.python2Packages.markupsafe;
    pytz = nixpkgs.python2Packages.pytz;
    nauty = nixpkgs.nauty;
    # Does not work with networkx 2.x yet -- see https://trac.sagemath.org/ticket/24374
    # networkx = nixpkgs.python2Packages.networkx;

    distutils = nixpkgs.python2Packages.distutils;
    cython = nixpkgs.python2Packages.cython;
    cysignals = nixpkgs.python2Packages.cysignals;
    readline = nixpkgs.readline;
    libpng = nixpkgs.libpng;

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
    twisted = nixpkgs.python2Packages.twisted; # with service-identity
    service-identity = nixpkgs.python2Packages.service-identity;
    pexpect = nixpkgs.python2Packages.pexpect;
    ptyprocess = nixpkgs.python2Packages.ptyprocess;

    sagelib = newpkgs.callPackage ./sagelib.nix {};
    sagedoc = newpkgs.callPackage ./sagedoc.nix {};
    sage = newpkgs.callPackage ./sage.nix { buildDoc = false; };
    pari_data = newpkgs.callPackage ./pari_data.nix {};
    sage-src = newpkgs.callPackage ./sage-src.nix {};

    pickleshare = nixpkgs.python2Packages.pickleshare;
    givaro = nixpkgs.givaro;
    six = nixpkgs.python2Packages.six;
    fflas_ffpack = nixpkgs.fflas-ffpack;
    linbox = nixpkgs.linbox.override { withSage = true; };
    imagesize = nixpkgs.python2Packages.imagesize;
    ipykernel = nixpkgs.python2Packages.ipykernel;
    dateutil = nixpkgs.python2Packages.dateutil;
    #ecl = nixpkgs.ecl;
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
    #ipython = nixpkgs.python2Packages.ipython;
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
    jinja2 = nixpkgs.python2Packages.jinja2;
    future = nixpkgs.python2Packages.future;
    psutil = nixpkgs.python2Packages.psutil;
    #eclib = nixpkgs.eclib;
    pyparsing = nixpkgs.python2Packages.pyparsing;
    #glpk = nixpkgs.glpk;
    cddlib = nixpkgs.cddlib;
    singular = nixpkgs.singular;
    #openblas = nixpkgs.openblas;
    ratpoints = nixpkgs.ratpoints;
    alabaster = nixpkgs.python2Packages.alabaster;
    pygments = nixpkgs.python2Packages.pygments;
    #gfan = nixpkgs.gfan;
    #cvxopt = nixpkgs.python2Packages.cvxopt;
    #sympy = nixpkgs.python2Packages.sympy;
    #arb = nixpkgs.arb;
    #matplotlib = nixpkgs.python2Packages.matplotlib;
    speaklater = nixpkgs.python2Packages.speaklater;
    libgap = nixpkgs.libgap;
    ppl = nixpkgs.ppl;
    #symmetrica = nixpkgs.symmetrica;
    cycler = nixpkgs.python2Packages.cycler;
    #flask = nixpkgs.python2Packages.flask;
    traitlets = nixpkgs.python2Packages.traitlets;
    pyzmq = nixpkgs.python2Packages.pyzmq;
    requests = nixpkgs.python2Packages.requests;
    #typing = nixpkgs.python2Packages.typing;
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
