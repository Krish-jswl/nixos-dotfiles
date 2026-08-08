{ lib, vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "vim-tomorrow-theme";
  version = "unstable-2025-01-01";

  src = fetchFromGitHub {
    owner = "chriskempson";
    repo = "vim-tomorrow-theme";
    rev = "master";
    hash = "sha256-DFpSJHGlN32XYecR0vPqyyLFTBwHRT21hoBA964JBcc=";
  };

  meta = with lib; {
    description = "Tomorrow theme for Vim";
    homepage = "https://github.com/chriskempson/vim-tomorrow-theme";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
