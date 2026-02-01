{ config, pkgs, ... }:


{
	home.username = "krishj";
	home.homeDirectory = "/home/krishj";
	home.stateVersion = "25.05";

    imports = [
      ./modules/home/default.nix
    ];

    xdg.userDirs.enable = true;

}
