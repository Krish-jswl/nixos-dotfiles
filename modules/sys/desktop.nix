{ pkgs, config, ... }:

{
  programs.niri.enable = true;

  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  services.greetd = {
    enable = true;

    settings.default_session.command = ''
      ${pkgs.tuigreet}/bin/tuigreet \
        --time \
        --remember \
        --cmd "${config.programs.niri.package}/bin/niri-session"
    '';
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    config = {
      common.default = [ "gtk" ];
    };
  };

  programs.dconf.enable = true;
}
