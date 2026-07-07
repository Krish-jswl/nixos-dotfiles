{
  imports = [
    ./hardware-configuration.nix
    ./modules/sys
  ];

  services.displayManager.ly.enable = false;

  system.stateVersion = "25.11";
}
