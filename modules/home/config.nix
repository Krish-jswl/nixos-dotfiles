{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  link = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    hypr     = "hypr";
    nvim     = "nvim";
    fuzzel   = "fuzzel";
    waybar   = "waybar";
    zathura  = "zathura";
    mako     = "mako";
    niri     = "niri";
    swaylock = "swaylock";
    kitty    = "kitty";
  };
in
{
  xdg.configFile =
    builtins.mapAttrs (_: subpath: {
      source = link "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}

