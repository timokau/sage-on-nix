{ pkgs, stdenv, pari_galdata, pari_seadata_small }:
pkgs.stdenv.mkDerivation rec {
  version = "${pari_galdata.version}-${pari_seadata_small.version}";
  name = "spkg-pari_data-${version}";

  buildInputs = [ ];

  unpackPhase = "true";

  configurePhase = "true";

  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out/share/pari"
    ln -s "${pari_galdata}/share/pari/galdata" "$out/share/pari"
    ln -s "${pari_seadata_small}/share/pari/seadata" "$out/share/pari"
  '';
}
