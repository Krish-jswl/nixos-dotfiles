{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.systemd-boot.enable = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.tlp.enable = true;

  boot.kernelParams = [ "amd_pstate=active" ];

  powerManagement.cpuFreqGovernor = "power saver";

  services.power-profiles-daemon.enable = false;

  # Enable Postgresql
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
  };


  # Enables docker
  virtualisation.docker.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  
  programs.hyprland.enable = true;

  programs.hyprland.xwayland.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc
      libGL
      mesa
      vulkan-loader
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXinerama
      alsa-lib
];

  services.displayManager.ly.enable = true;
  
  systemd.services.fix-mic-led = {
    description = "Force microphone LED off";
    wantedBy = [ "multi-user.target" "sleep.target" ];
    after = [ "sysinit.target" "suspend.target" "hibernate.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c 'echo 0 > /sys/class/leds/platform::micmute/brightness'";
    };
  };


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
   services.pipewire = {
     enable = true;
     pulse.enable = true;
     alsa.enable = true;
     jack.enable = true;
   };

   xdg.portal = {
     enable = true;
     wlr.enable = true;
     extraPortals = [
       pkgs.xdg-desktop-portal-hyprland
     ];
   };

  services.dbus.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.krishj = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    foot
    nautilus
    mesa
    mesa-demos
    gvfs
  ];


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.terminess-ttf
    nerd-fonts.caskaydia-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";

}

