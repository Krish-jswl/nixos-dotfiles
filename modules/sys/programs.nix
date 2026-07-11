{ pkgs, ... }:

{
  programs.zsh.enable = true;

  programs.steam.enable = true;

  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      stdenv.cc.cc
      libGL
      vulkan-loader
      libX11
      libXcursor
      libXrandr
      libXinerama
      alsa-lib
    ];
  };
}
