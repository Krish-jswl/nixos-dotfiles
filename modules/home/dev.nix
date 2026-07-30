{ pkgs, ... }:

{

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
  };

  home.packages = with pkgs; [
    # dev tooling
    gcc
    cmake
    gnumake
    pkg-config
    bear
    jq

    # languages
    go
    python3
    rustup

    # formater
    clang-tools
    nixfmt
    prettier
    black
    shfmt
    stylua

    # utilities
    unzip
    gnutar
    gzip
    ripgrep
    fzf
    fd

  ];
}
