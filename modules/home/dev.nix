{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    extraPackages = with pkgs; [
      tree-sitter
      clang-tools
      gopls
      pyright
      nil
      bash-language-server
      typescript-language-server
      vscode-langservers-extracted
    ];
  };
}

