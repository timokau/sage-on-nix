let
  newpkgs = spkgs (newpkgs // overrides);
  spkgs = import ./all.nix;
  nixpkgs = import <nixpkgs> {};
  overrides = {
    gcc = nixpkgs.gcc;
    gfortran = nixpkgs.gfortran6;
    pkgconf = nixpkgs.pkgconfig;
    pkgconfig = nixpkgs.python2Packages.pkgconfig;
    python = nixpkgs.python2;
    python2 = nixpkgs.python2;
    python3 = nixpkgs.python3;
    # flint = nixpkgs.flint;
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
    networkx = nixpkgs.python2Packages.networkx;

    distutils = nixpkgs.python2Packages.distutils; 
    cython = nixpkgs.python2Packages.cython;

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
    #givaro = nixpkgs.givaro;
    #six = nixpkgs.python2Packages.six;
    #fflas_ffpack = nixpkgs.fflas-ffpack;
    #linbox = nixpkgs.linbox;
    #imagesize = nixpkgs.python2Packages.imagesize;
    #ipykernel = nixpkgs.python2Packages.ipykernel;
    #dateutil = nixpkgs.python2Packages.dateutil;
    #ecl = nixpkgs.ecl;
    #wcwidth = nixpkgs.python2Packages.wcwidth;
    #pari = nixpkgs.pari;
    #giac = nixpkgs.giac;
    #ipython = nixpkgs.python2Packages.ipython;
    #pathlib = nixpkgs.python2Packages.pathlib;
    #scipy = nixpkgs.python2Packages.scipy;
    #itsdangerous = nixpkgs.python2Packages.itsdangerous;
    #enum34 = nixpkgs.python2Packages.enum34;
    #werkzeug = nixpkgs.python2Packages.werkzeug;
    #tachyon = nixpkgs.tachyon;
    #snowballstemmer = nixpkgs.python2Packages.snowballstemmer;
    #numpy = nixpkgs.python2Packages.numpy;
    #jinja2 = nixpkgs.python2Packages.jinja2;
    #future = nixpkgs.python2Packages.future;
    #psutil = nixpkgs.python2Packages.psutil;
    #eclib = nixpkgs.eclib;
    #pyparsing = nixpkgs.python2Packages.pyparsing;
    #glpk = nixpkgs.glpk;
    #cddlib = nixpkgs.cddlib;
    #singular = nixpkgs.singular;
    #ratpoints = nixpkgs.ratpoints;
    #alabaster = nixpkgs.python2Packages.alabaster;
    #pygments = nixpkgs.python2Packages.pygments;
    #gfan = nixpkgs.gfan;
    #cvxopt = nixpkgs.python2Packages.cvxopt;
    #sympy = nixpkgs.python2Packages.sympy;
    #arb = nixpkgs.arb;
    #matplotlib = nixpkgs.python2Packages.matplotlib;
    #speaklater = nixpkgs.python2Packages.speaklater;
    #libgap = nixpkgs.libgap;
    #ppl = nixpkgs.ppl;
    #symmetrica = nixpkgs.symmetrica;
    #cycler = nixpkgs.python2Packages.cycler;
    #flask = nixpkgs.python2Packages.flask;
    #traitlets = nixpkgs.python2Packages.traitlets;
    #pyzmq = nixpkgs.python2Packages.pyzmq;
    #requests = nixpkgs.python2Packages.requests;
    #typing = nixpkgs.python2Packages.typing;
    #sphinx = nixpkgs.python2Packages.sphinx;
    #mpmath = nixpkgs.python2Packages.mpmath;
    #gap = nixpkgs.gap;
    #zope_interface = nixpkgs.python2Packages.zope_interface;
    #mpfr = nixpkgs.mpfr;
  };
in
  newpkgs // overrides
