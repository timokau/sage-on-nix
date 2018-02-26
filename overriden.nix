let
  newpkgs = spkgs (newpkgs // overrides);
  spkgs = import ./all.nix;
  nixpkgs = import <nixpkgs> {};
  overrides = {
    gcc = nixpkgs.gcc;
    pkgconf = nixpkgs.pkgconfig;
    pkgconfig = nixpkgs.pkgconfig;
  };
in
  newpkgs // overrides
