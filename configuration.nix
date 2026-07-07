{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/sys/boot.nix
    ./modules/sys/hardware.nix
    ./modules/sys/networking.nix
    ./modules/sys/power.nix
    ./modules/sys/desktop.nix
    ./modules/sys/audio.nix
    ./modules/sys/security.nix
    ./modules/sys/services.nix
    ./modules/sys/virtualization.nix
    ./modules/sys/programs.nix
    ./modules/sys/users.nix
    ./modules/sys/packages.nix
    ./modules/sys/fonts.nix
    ./modules/sys/localization.nix
    ./modules/sys/nix.nix
  ];

  system.stateVersion = "25.11";
}
