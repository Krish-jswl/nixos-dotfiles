{ ... }:
{
  programs.nixvim.plugins.toggleterm = {
    enable = true;

    settings = {
      direction = "float";
      open_mapping = "[[<c-\\>]]";
      shade_terminals = false;

      float_opts = {
        border = "rounded";
      };
    };
  };
}
