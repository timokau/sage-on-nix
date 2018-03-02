let
  newpkgs = spkgs (newpkgs // overrides);
  spkgs = import ./all.nix;
  nixpkgs = import <nixpkgs> {};
  overrides = {
    gcc = nixpkgs.gcc;
    gfortarn = nixpkgs.gfortran6;
    pkgconf = nixpkgs.pkgconfig;
    pkgconfig = nixpkgs.python2Packages.pkgconfig;
    python3 = nixpkgs.python3;
    setuptools = nixpkgs.python2Packages.setuptools;
    pip = nixpkgs.python2Packages.pip;
    libgd = nixpkgs.gd; # TODO check why sages gd doesn't provide Png functionality
    pillow = nixpkgs.python2Packages.pillow;
    r = nixpkgs.R;
    # maxima = nixpkgs.maxima;
    # ecl = nixpkgs.ecl;

    sagelib = newpkgs.callPackage ./sagelib.nix {};
    sage = newpkgs.callPackage ./sage.nix {};
    # experiments
    # singular = nixpkgs.singular;
    # openblas = nixpkgs.openblas;
    # pynac = nixpkgs.python2Packages.pynac;
    # fflas_ffpack = nixpkgs.fflas-ffpack;
    # linbox = nixpkgs.linbox;
  };
in
  newpkgs // overrides
