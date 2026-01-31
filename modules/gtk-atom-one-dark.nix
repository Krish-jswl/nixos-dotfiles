{ pkgs, ... }:

let
  atomOneDarkTheme = pkgs.stdenv.mkDerivation {
    pname = "atom-one-dark-gtk";
    version = "2025";

    src = pkgs.fetchFromGitHub {
      owner = "UnnatShaneshwar";
      repo = "AtomOneDarkTheme";
      rev = "main";
      sha256 = "sha256-JbE9uVtlIIb0ei/XuZ2/Ccl3W2SyTYYLZgkbaXf9P2A=";
    };

    installPhase = ''
      mkdir -p $out/share/themes/AtomOneDark
      cp -r gtk-2.0 gtk-3.0 $out/share/themes/AtomOneDark/
    '';
  };
in
{
  gtk = {
    enable = true;

    theme = {
      name = "AtomOneDark";
      package = atomOneDarkTheme;
    };

    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = true;
    };
  };
}

