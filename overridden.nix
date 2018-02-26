let original = import ./all.nix;
pkgs = import <nixpkgs> {};
in
original // {
  gcc = pkgs.gcc;
  pkgconf = pkgs.pkgconfig;
  #gap = original.gap.override {
  #  additionalPatch = ''
  #    substituteInPlace ./spkg-install \
  #      --replace '--with-gmp="$SAGE_LOCAL"' '--with-gmp="system"'
  #    '';
  #};
  #ecl = original.ecl.override {
  #  additionalPatch = ''
  #    substituteInPlace ./src/configure \
  #      --replace 'export buildir' 'export buildir; export ECL_NEWLINE=LF'
  #    '';
  #};
}
