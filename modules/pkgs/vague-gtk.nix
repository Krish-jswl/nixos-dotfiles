{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "vague-gtk-theme";
  version = "unstable-2026-08-28";

  src = pkgs.fetchFromGitHub {
    owner = "vague-theme";
    repo = "vague-gtk";
    rev = "main";
    hash = "sha256-eEP4r/0Kb7RyB45pSe47bHwAx40gG/3XWGlr/UB7g4g=";
  };

  installPhase = ''
    mkdir -p $out/share/themes

    cp -r * $out/share/themes/
  '';

  meta = {
    description = "Vague GTK theme";
    homepage = "https://github.com/vague-theme/vague-gtk";
    license = pkgs.lib.licenses.mit;
  };
}
