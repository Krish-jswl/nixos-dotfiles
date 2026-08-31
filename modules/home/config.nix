{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  link = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    hypr = "hypr";
    fuzzel = "fuzzel";
    waybar = "waybar";
    niri = "niri";
    kitty = "kitty";
    sioyek = "sioyek";
    quickshell = "quickshell";
  };
in
{
  xdg.configFile = builtins.mapAttrs (_: subpath: {
    source = link "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
}
