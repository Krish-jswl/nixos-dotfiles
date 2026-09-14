{ pkgs, ... }:

{
  services.blueman.enable = true;
  programs.nm-applet.enable = true;

  services.udev.extraRules = ''
    # URX Core68 HE
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3151", ATTRS{idProduct}=="5029", MODE:="0660", TAG+="uaccess"

    # URX Core68 Update Mode
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3151", ATTRS{idProduct}=="502a", MODE:="0660", TAG+="uaccess"

    # URX Core75
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="3130", MODE:="0660", TAG+="uaccess"

    # URX Core75 2.4G
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="3002", MODE:="0660", TAG+="uaccess"

    # URX Core M1 Wired
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3151", ATTRS{idProduct}=="5043", MODE:="0660", TAG+="uaccess"

    # URX Core M1 2.4G
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3151", ATTRS{idProduct}=="5045", MODE:="0660", TAG+="uaccess"

    # URX Core M1 Bluetooth
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3151", ATTRS{idProduct}=="503c", MODE:="0660", TAG+="uaccess"
  '';

  services.tumbler.enable = true;

  services.dbus.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  services.upower.enable = true;

  services.postgresql = {
    enable = false;

    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };

  systemd.services.fix-mic-led = {
    description = "Force microphone LED off";

    wantedBy = [
      "multi-user.target"
      "sleep.target"
    ];

    after = [
      "sysinit.target"
      "suspend.target"
      "hibernate.target"
    ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/sh -c 'echo 0 > /sys/class/leds/platform::micmute/brightness'";
    };
  };
}
