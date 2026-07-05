{ pkgs, ... }:

let
  tairiki = pkgs.callPackage ../pkgs/tairiki.nix { };
in

{
  programs.nixvim = {
    extraPlugins = [
      tairiki
    ];

    colorschemes = {
    };

    extraConfigLua = ''
      vim.cmd.colorscheme("tairiki")

            local transparent_groups = {
          "Normal",
          "NormalNC",
          "NormalFloat",
          "SignColumn",
          "EndOfBuffer",
          "FoldColumn",
          "CursorLineNr",
          "NvimTreeNormal",
          "NvimTreeNormalNC",
          "TelescopeNormal",
          "TelescopeBorder",
        }

        for _, group in ipairs(transparent_groups) do
          vim.api.nvim_set_hl(0, group, { bg = "none" })
        end
        ---

        -- Diagnostic
        vim.o.updatetime = 300

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
        ---

        --- Round Border
      vim.o.winborder = "rounded"

      vim.diagnostic.config({
        float = {
          border = "rounded",
          source = "if_many",
        },
      })
      ---

    '';
  };
}
