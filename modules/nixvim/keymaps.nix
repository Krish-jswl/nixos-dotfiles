{ ... }:

{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>nh";
      action = "<cmd>nohlsearch<CR>";
    }
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
      options.desc = "Move down in buffer centered";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
      options.desc = "Move up in buffer centered";
    }
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
      options.desc = "Next search result centered";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
      options.desc = "Previous search result centered";
    }
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      options.desc = "Move lines down";
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      options.desc = "Move lines up";
    }
    {
      mode = "n";
      key = "<";
      action = "<gv";
      options.desc = "Unindent and keep selection";
    }
    {
      mode = "n";
      key = ">";
      action = ">gv";
      options.desc = "Indent and keep selection";
    }

    # Lsp Keymaps
    {
      mode = "n";
      key = "gd";
      action = "<cmd>lua vim.lsp.buf.definition()<CR>";
      options.desc = "Go to definition";
    }

    {
      mode = "n";
      key = "gr";
      action = "<cmd>lua vim.lsp.buf.references()<CR>";
      options.desc = "References";
    }

    {
      mode = "n";
      key = "gi";
      action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
      options.desc = "Implementation";
    }

    {
      mode = "n";
      key = "K";
      action = "<cmd>lua vim.lsp.buf.hover()<CR>";
      options.desc = "Hover";
    }

    {
      mode = "n";
      key = "<leader>rn";
      action = "<cmd>lua vim.lsp.buf.rename()<CR>";
      options.desc = "Rename";
    }

    {
      mode = "n";
      key = "<leader>ca";
      action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
      options.desc = "Code Action";
    }

    # Conform
    {
      mode = "n";
      key = "<leader>cf";

      action.__raw = ''
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
          })
        end
      '';

      options.desc = "Format buffer";
    }

    # GitSigns
    {
      mode = "n";
      key = "]h";
      action = "<cmd>Gitsigns next_hunk<CR>";
      options.desc = "Next Git hunk";
    }
    {
      mode = "n";
      key = "[h";
      action = "<cmd>Gitsigns prev_hunk<CR>";
      options.desc = "Previous Git hunk";
    }
    {
      mode = "n";
      key = "<leader>hp";
      action = "<cmd>Gitsigns preview_hunk<CR>";
      options.desc = "Preview hunk";
    }
    {
      mode = "n";
      key = "<leader>hs";
      action = "<cmd>Gitsigns stage_hunk<CR>";
      options.desc = "Stage hunk";
    }
    {
      mode = "n";
      key = "<leader>hr";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options.desc = "Reset hunk";
    }
    {
      mode = "n";
      key = "<leader>hb";
      action = "<cmd>Gitsigns blame_line<CR>";
      options.desc = "Git blame";
    }

    # Nvim Tree
    {
      mode = "n";
      key = "<leader>ee";
      action = "<cmd>NvimTreeToggle<CR>";
      options.desc = "Toggle file explorer";
    }

    # Toggle Term
    {
      mode = "n";
      key = "<leader>th";
      action = "<cmd>ToggleTerm direction=horizontal<CR>";
      options.desc = "horizontal split terminal";
    }
    {
      mode = "t";
      key = "<Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Exit terminal mode";
    }

    # Indent blank Line Toggle
    {
      mode = "n";
      key = "<leader>ti";
      action = "<cmd>IBLToggle<CR>";
      options.desc = "Toggle indent guides";
    }

    # LuaSnipp
    {
      mode = [
        "i"
        "s"
      ];
      key = "<C-l>";

      action.__raw = ''
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end
      '';
    }

    {
      mode = [
        "i"
        "s"
      ];
      key = "<C-h>";

      action.__raw = ''
        function()
          local ls = require("luasnip")
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end
      '';
    }

  ];
}
