{ pkgs, ... }:

{
  services.blueman.enable = true;

  services.tumbler.enable = true;

  services.dbus.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

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
