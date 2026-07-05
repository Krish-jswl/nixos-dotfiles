{ ... }:

{
  programs.nixvim.plugins.telescope = {
    enable = true;

    keymaps = {
      "<leader>ff" = {
        action = "find_files";
        options.desc = "Find files";
      };

      "<leader>fg" = {
        action = "live_grep";
        options.desc = "Live grep";
      };

      "<leader>fb" = {
        action = "buffers";
        options.desc = "Buffers";
      };

      "<leader>fh" = {
        action = "help_tags";
        options.desc = "Help";
      };

      "<leader>fr" = {
        action = "lsp_references";
      };

      "<leader>fs" = {
        action = "lsp_document_symbols";
      };

      "<leader>fd" = {
        action = "diagnostics";
      };
    };
  };
}
