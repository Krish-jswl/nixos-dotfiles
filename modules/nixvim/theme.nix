{
  programs.nixvim = {
    enable = true;

    colorschemes.tokyonight = {
      enable = true;

      settings = {
        style = "night";
        transparent = true;
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
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local cfg = vim.api.nvim_win_get_config(win)
            if cfg.relative ~= "" then
              return
            end
          end

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
