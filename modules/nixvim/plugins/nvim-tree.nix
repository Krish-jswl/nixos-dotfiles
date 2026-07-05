{ ... }:

{
  programs.nixvim.plugins.nvim-tree = {
    enable = true;

    settings = {
      view = {
        width = 30;
        side = "right";
      };

      renderer = {
        group_empty = true;

        icons = {
          show = {
            git = true;
            folder = true;
            file = true;
            folder_arrow = true;
          };
        };
      };

      filters.dotfiles = false;
    };
  };
}
