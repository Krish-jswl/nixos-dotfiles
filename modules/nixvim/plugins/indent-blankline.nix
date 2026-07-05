{ ... }:
{
  programs.nixvim.plugins.indent-blankline = {
    enable = true;

    settings = {
      enabled = false;

      indent = {
        char = "│";
      };

      scope = {
        enabled = true;
        show_start = false;
        show_end = false;
      };
    };
  };
}
