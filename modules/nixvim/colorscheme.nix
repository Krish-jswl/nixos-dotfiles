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
    };

    extraConfigLua = ''
      vim.cmd.colorscheme("tairiki")
    '';
  };
}
