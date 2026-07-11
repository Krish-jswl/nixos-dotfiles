{
  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox-material = {
      enable = true;

      settings = {
        background = "hard";
        transparent_background = 1;
        disable_italic_comment = 1;
        ui_contrast = "high";
      };
    };

    extraConfigLua = ''
      vim.o.updatetime = 300
      vim.o.winborder = "rounded"

      vim.diagnostic.config({
        virtual_text = false,
        underline = true,
        update_in_insert = false,
        severity_sort = true,

        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN]  = "󰀪 ",
            [vim.diagnostic.severity.INFO]  = "󰋽 ",
            [vim.diagnostic.severity.HINT]  = "󰌶 ",
          },
        },

        float = {
          border = "rounded",
          source = "if_many",
        },
      })

      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, {
            focusable = false,
            border = "rounded",
            source = "if_many",
            scope = "cursor",
          })
        end,
      })
    '';
  };
}
