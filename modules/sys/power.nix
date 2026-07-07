{ ... }:

{
  services.tlp = {
    enable = true;

    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_BAT = 0;

      PCIE_ASPM_ON_BAT = "powersupersave";
      RUNTIME_PM_ON_BAT = "auto";
      WIFI_PWR_ON_BAT = "on";
      USB_AUTOSUSPEND = 1;
    };
  };

  services.power-profiles-daemon.enable = false;
}
