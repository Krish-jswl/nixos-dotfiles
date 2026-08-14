{ ... }:

{
  networking.hostName = "nixos";

  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };
}
