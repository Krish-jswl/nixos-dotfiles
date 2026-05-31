{ config, pkgs, ... }:

{
  programs.neovim = {
    withPython3 = false;
    withRuby = false;
    enable = true;
    extraLuaConfig = builtins.readFile ../../config/nvim/init.lua;

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

