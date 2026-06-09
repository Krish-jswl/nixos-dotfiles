{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "tomorrow-night-gtk";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "woof-os";
    repo = "tomorrow-night-gtk";
    rev = "master";
    hash = "sha256-DK2Lx37Xn4Oi20HKyyndgDpW7UZrepUkT0xcnIBEhjo=";
  };

  installPhase = ''
    mkdir -p $out/share/themes/tomorrow-night
    cp -r ./* $out/share/themes/tomorrow-night/
  '';
}
