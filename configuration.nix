{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.efi.canTouchEfiVariables = true;

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
  networking.networkmanager.wifi.powersave = false;
  programs.nm-applet.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.tlp = {
    enable = false;

    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_BAT = 0;

      PCIE_ASPM_ON_BAT = "powersupersave";

      RUNTIME_PM_ON_BAT = "auto";

      WIFI_PWR_ON_BAT = "off";

      USB_AUTOSUSPEND = 1;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.kernelParams = [ "amd_pstate=active" ];


  services.power-profiles-daemon.enable = false;

  # Enable Postgresql
  services.postgresql = {
    enable = false;

    ensureDatabases = [ "gokit" ];

    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host  all all 127.0.0.1/32 trust
      host  all all ::1/128 trust
    '';
  };

  services.tumbler.enable = true;

  # Enables docker
  virtualisation.docker.enable = false;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  programs.mango.enable = true;

  xdg.portal = {
    enable = true;

    wlr.enable = true;
    config = {
      common = {
        default = [ "wlr" ];
      };
    };
  };

  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.firefox.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc
      libGL
      vulkan-loader
      libX11
      libXcursor
      libXrandr
      libXinerama
      alsa-lib
];

  services.displayManager.ly.enable = false;
  
  systemd.services.fix-mic-led = {
    description = "Force microphone LED off";
    wantedBy = [ "multi-user.target" "sleep.target" ];
    after = [ "sysinit.target" "suspend.target" "hibernate.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/sh -c 'echo 0 > /sys/class/leds/platform::micmute/brightness'";
    };
  };


  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;
    jack.enable = true;
  };

  security.rtkit.enable = true;

  services.dbus.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.krishj = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" "video" "networkmanager" ];
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    foot
    mesa-demos
    pciutils
  ];


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";

}

