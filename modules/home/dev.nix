{ pkgs, ... }:

{

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.quickshell = {
    enable = true;
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
    rustup
    python3

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
