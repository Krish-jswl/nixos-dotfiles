{ ... }:

{
  programs.nixvim.plugins.colorizer = {
    enable = true;

    settings = {
      user_default_options = {
        RGB = true;
        RRGGBB = true;
        RRGGBBAA = true;
        AARRGGBB = true;

        rgb_fn = true;
        hsl_fn = true;
        css = true;
        css_fn = true;

        names = true;

        tailwind = true;

        mode = "background";
      };
    };
  };
}
