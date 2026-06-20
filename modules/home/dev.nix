{ pkgs, ... }:

{
  # programs.emacs = {
  #   enable = true;
  #   package = pkgs.emacs-pgtk;
  # };
  #
  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  # }; 

  home.packages = with pkgs; [
    # C/C++ tooling
    gcc
    clang-tools
    cmake
    gnumake
    pkg-config
    bear

    # General development
    ripgrep
    fzf
    go
    python3

    # Archive utilities
    unzip
    gnutar
    gzip

  ];
}
