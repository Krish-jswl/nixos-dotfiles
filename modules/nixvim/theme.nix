{
  programs.nixvim = {
    enable = true;

    colorschemes.everforest = {
      enable = true;

      settings = {
        background = "hard";
        transparent_background = 2;
        disable_italic_comment = 1;
        ui_contrast = "high";
      };
    };

    extraConfigLua = ''
      local transparent_groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "SignColumn",
        "EndOfBuffer",
        "FoldColumn",
        "CursorLineNr",
        "TelescopeNormal",
        "TelescopeBorder",
      }

      for _, group in ipairs(transparent_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end

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
