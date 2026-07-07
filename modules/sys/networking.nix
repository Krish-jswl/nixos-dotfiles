{ ... }:

{
  networking.hostName = "nixos";

  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  programs.nm-applet.enable = true;
}
