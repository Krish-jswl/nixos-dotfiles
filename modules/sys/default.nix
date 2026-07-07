{ ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./power.nix
    ./desktop.nix
    ./audio.nix
    ./security.nix
    ./services.nix
    ./virtualization.nix
    ./programs.nix
    ./users.nix
    ./packages.nix
    ./fonts.nix
    ./localization.nix
    ./nix.nix
  ];
}
