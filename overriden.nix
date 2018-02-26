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
  };
in
  newpkgs // overrides
