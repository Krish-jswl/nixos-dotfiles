{ pkgs, ... }:

let
  tairiki = pkgs.callPackage ../pkgs/tairiki.nix { };
in

{
  programs.nixvim = {
    extraPlugins = [
      tairiki
    ];

    colorschemes = {
      # Leave empty/disabled if Tairiki isn't a built-in colorscheme.
    };

    extraConfigLua = ''
      vim.cmd.colorscheme("tairiki")
    '';
  };
}
