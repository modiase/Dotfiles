{ stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  name = "moye-fish-plugins";
  src = ./.;
  installPhase = ''
    mkdir -p $out/share/fish/vendor_functions.d
    cp *.fish $out/share/fish/vendor_functions.d
  '';
}
