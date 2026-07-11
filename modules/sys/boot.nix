{ pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };

  boot.initrd.luks.devices."cryptswap" = {
    device = "/dev/disk/by-uuid/6d010916-e4e7-40c3-835a-d020abd8dec0";
  };

  swapDevices = [
    {
      device = "/dev/mapper/cryptswap";
    }
  ];

  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams = [ "amd_pstate=active" ];
}
