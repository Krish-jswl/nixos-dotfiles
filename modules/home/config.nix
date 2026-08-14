{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  link = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    niri = "niri";
    kitty = "kitty";
    sioyek = "sioyek";
  };
in
{
  xdg.configFile = builtins.mapAttrs (_: subpath: {
    source = link "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
}
