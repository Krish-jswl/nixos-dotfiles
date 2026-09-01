{ pkgs, lib }:

{
  flexokiGtk = pkgs.stdenvNoCC.mkDerivation {
    pname = "flexoki-gtk-theme";
    version = "unstable-2026-09-01";

    src = pkgs.fetchFromGitHub {
      owner = "kepano";
      repo = "flexoki";
      rev = "8d723bac4a9ac46adfdf99d42155286977aac72a";
      hash = "sha256-IxnvoZ9hGEvwq/PBbHTL5L2a2kxMSXSINIfd5Dg9ttA=";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes/flexoki
      cp -r $src/gtk/* $out/share/themes/flexoki/
      runHook postInstall
    '';

    meta = with lib; {
      description = "Flexoki GTK theme (fork of adw-gtk3)";
      homepage = "https://github.com/kepano/flexoki";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };
}
