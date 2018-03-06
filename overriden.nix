let
  newpkgs = spkgs (newpkgs // overrides);
  spkgs = import ./all.nix;
  nixpkgs = import <nixpkgs> {};
  overrides = {
    gcc = nixpkgs.gcc;
    gfortarn = nixpkgs.gfortran6;
    pkgconf = nixpkgs.pkgconfig;
    pkgconfig = nixpkgs.python2Packages.pkgconfig;
    python = nixpkgs.python2;
    python2 = nixpkgs.python2;
    python3 = nixpkgs.python3;
    flint = nixpkgs.flint;
    setuptools = nixpkgs.python2Packages.setuptools;
    pip = nixpkgs.python2Packages.pip;
    libgd = nixpkgs.gd; # TODO check why sages gd doesn't provide Png functionality
    pillow = nixpkgs.python2Packages.pillow;

    # Fixes https://bugs.python.org/issue1222585, upstream sage fixes that by patching python (TODO change that upstream?)
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
    # ecl = nixpkgs.ecl;
    ecm = nixpkgs.ecm;
    # maxima = nixpkgs.maxima-ecl;
    jupyter_client = nixpkgs.python2Packages.jupyter_client;
    jupyter_core = nixpkgs.python2Packages.jupyter_core;
    twisted = nixpkgs.python2Packages.twisted; # with service-identity

    sagelib = newpkgs.callPackage ./sagelib.nix {};
    sagedoc = newpkgs.callPackage ./sagedoc.nix {};
    sage = newpkgs.callPackage ./sage.nix {};
    pari_data = newpkgs.callPackage ./pari_data.nix {};
    sage-src = newpkgs.callPackage ./sage-src.nix {};
    # experiments
    # singular = nixpkgs.singular;
    ########
    # otherwise fix needed: openblas doesn't get detected by pkgconfig.parse('cblas')
    # TODO needs `cblas` pkgconfig alias
    # openblas = nixpkgs.openblas; 
    # numpy = nixpkgs.python2Packages.numpy; 
    # scipy = nixpkgs.python2Packages.scipy; 
    # fflas_ffpack = nixpkgs.fflas-ffpack;
    # givaro = nixpkgs.givaro;
    # linbox = nixpkgs.linbox;
    # giac = nixpkgs.giac;
    ########
    # pynac = nixpkgs.python2Packages.pynac;
    # fflas_ffpack = nixpkgs.fflas-ffpack;
    # linbox = nixpkgs.linbox;
  };
in
  newpkgs // overrides
