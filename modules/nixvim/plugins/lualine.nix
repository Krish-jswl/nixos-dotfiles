{ ... }:

{
  programs.nixvim.plugins.lualine = {
    enable = true;

    settings = {
      options = {
        globalstatus = true;

        theme = "auto";

        component_separators = "";
        section_separators = "";
      };

      sections = {
        lualine_a = [ "mode" ];

        lualine_b = [
          "branch"
          "diff"
        ];

        lualine_c = [ "filename" ];

        lualine_x = [
          "diagnostics"
          "filetype"
        ];

        lualine_y = [ "progress" ];

        lualine_z = [ "location" ];
      };
    };
  };
}
