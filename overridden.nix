let original = import ./all.nix;
pkgs = import <nixpkgs> {};
in
original // {
  ecm = original.ecm.override {
    additionalPatch = ''
      substituteInPlace ./spkg-install \
        --replace '"$SAGE_LOCAL"/include/gmp.h' '"${pkgs.gmp.dev}/include/gmph.h"' \
        --replace '--with-gmp="$SAGE_LOCAL"' '--with-gmp-include="${pkgs.gmp.dev}" --with-gmp-lib="${pkgs.gmp}"'
      '';
        #--replace 'cp "$SAGE_ROOT"/config/config.*' '# TODO fix config.guess' \
  };
  gap = original.gap.override {
    additionalPatch = ''
      substituteInPlace ./spkg-install \
        --replace '--with-gmp="$SAGE_LOCAL"' '--with-gmp="system"'
      '';
  };
  ecl = original.ecl.override {
    additionalPatch = ''
      substituteInPlace ./src/configure \
        --replace 'export buildir' 'export buildir; export ECL_NEWLINE=LF'
      '';
  };
}
