{ pkgs, ... }:

{

  home.packages = with pkgs; [
    # dev tooling
    gcc
    cmake
    gnumake
    pkg-config
    bear

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
