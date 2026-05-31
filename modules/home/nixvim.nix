{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    # =========================================================================
    # GLOBALS & OPTIONS 
    # =========================================================================
    globals = {
      mapleader = " ";
      netrw_banner = 0;
      gruvbox_material_background = "medium";
      gruvbox_material_enable_italic = true;
    };

    opts = {
      nu = true;
      relativenumber = true;
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      wrap = true;
      smartindent = true;
      inccommand = "split";
      splitbelow = true;
      splitright = true;
      ignorecase = true;
      smartcase = true;
      laststatus = 3;
      swapfile = false;
      backup = false;
      undofile = true;
      completeopt = [ "menuone" "noselect" "fuzzy" "nosort" ];
      colorcolumn = "0";
      signcolumn = "yes";
      cmdheight = 0;
      termguicolors = true;
      scrolloff = 4;
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true; 
    };

    # =========================================================================
    # AUTOCOMMANDS 
    # =========================================================================
    autoCmd = [
      {
        event = "TextYankPost";
        desc = "Highlight when yanking (copying) text";
        callback = {
          __raw = "function() vim.hl.on_yank() end";
        };
      }
    ];

    # =========================================================================
    # KEYMAPS (ALL COMBINED)
    # =========================================================================
    keymaps = [
      # Normal Mode
      { mode = "n"; key = "<leader>nh"; action = "<cmd>nohl<CR>"; }
      { mode = "n"; key = "<"; action = "<gv"; options.desc = "Unindent and keep selection"; }
      { mode = "n"; key = ">"; action = ">gv"; options.desc = "Indent and keep selection"; }
      { mode = "n"; key = "<C-d>"; action = "<C-d>zz"; options.desc = "Move down in buffer centered"; }
      { mode = "n"; key = "<C-u>"; action = "<C-u>zz"; options.desc = "Move up in buffer centered"; }
      { mode = "n"; key = "n"; action = "nzzzv"; options.desc = "Next search result centered"; }
      { mode = "n"; key = "N"; action = "Nzzzv"; options.desc = "Previous search result centered"; }
      { mode = "n"; key = "<leader>u"; action = "<cmd>UndotreeToggle<CR>"; options.desc = "Toggle Undotree"; }
      
      # Plugin Toggles
      { mode = "n"; key = "<leader>ee"; action = "<cmd>NvimTreeToggle<CR>"; options.desc = "Toggle file explorer"; }
      
      # LSP Formatting (Raw lua for async)
      { mode = "n"; key = "<leader>f"; action.__raw = "function() vim.lsp.buf.format({ async = true }) end"; options.desc = "Format buffer"; }

      # Visual Mode
      { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; options.desc = "Move lines down"; }
      { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; options.desc = "Move lines up"; }
    ];

    # =========================================================================
    # CUSTOM PLUGINS & THEME
    # =========================================================================
    extraPlugins = with pkgs.vimPlugins; [
      gruvbox-material
    ];
    extraConfigLua = ''
      vim.cmd.colorscheme("gruvbox-material")
    '';

    # =========================================================================
    # PLUGINS 
    # =========================================================================
    plugins = {
      
      web-devicons.enable = true;
      undotree.enable = true;
      
      colorizer = {
        enable = true;
        settings.user_default_options = {
          RGB = true; RRGGBB = true; RRGGBBAA = true; AARRGGBB = true;
          names = true; rgb_fn = true; hsl_fn = true; css = true; css_fn = true;
          tailwind = true; mode = "background";
        };
      };

      nvim-tree = {
        enable = true;
        settings = {
          view.width = 30;
          renderer.group_empty = true;
          filters.dotfiles = false;
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>." = { action = "find_files"; options.desc = "Find files"; };
          "<leader>fs" = { action = "live_grep"; options.desc = "Live grep"; };
          "<leader>," = { action = "buffers"; options.desc = "Buffers"; };
          "<leader>fh" = { action = "help_tags"; options.desc = "Help tags"; };
          "<leader>fd" = { action = "diagnostics"; options.desc = "Diagnostics"; };
        };
      };

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
        };
      };

lsp = {
        enable = true;
        
        # Buffer-local LSP Mappings (Removed the "options." prefix here!)
        keymaps = {
          diagnostic = {
            "df" = { action = "open_float"; desc = "Line diagnostics"; };
            "[d" = { action = "goto_prev"; desc = "Previous diagnostic"; };
            "]d" = { action = "goto_next"; desc = "Next diagnostic"; };
          };
          lspBuf = {
            "gd" = { action = "definition"; desc = "Go to definition"; };
            "K" = { action = "hover"; desc = "Hover documentation"; };
            "gi" = { action = "implementation"; desc = "Go to implementation"; };
            "gr" = { action = "references"; desc = "References"; };
            "<leader>rn" = { action = "rename"; desc = "Rename symbol"; };
            "<leader>ca" = { action = "code_action"; desc = "Code actions"; };
          };
        };

        servers = {
          lua_ls.enable = true;
          marksman.enable = true;
          gopls.enable = true;
          pyright.enable = true;
          clangd = {
            enable = true;
            cmd = [ "clangd" "--offset-encoding=utf-16" ];
          };
          ts_ls.enable = true;
          html.enable = true;
          cssls.enable = true;
          tailwindcss.enable = true;
          jsonls.enable = true;
        };
      };
      luasnip = {
        enable = true;
        settings = {
          history = false;
          update_events = "TextChanged,TextChangedI";
        };
      };
      friendly-snippets.enable = true;

      cmp = {
        enable = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          completion.completeopt = "menu,menuone,noselect";
          
          window = {
            completion = { border = "rounded"; };
            documentation = { border = "rounded"; };
          };

          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })";
            
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<S-Tab>" = ''
              cmp.mapping(function(fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
          };

          sources = [
            { name = "nvim_lsp"; priority = 1000; }
            { name = "luasnip"; priority = 750; }
            { name = "buffer"; priority = 500; }
            { name = "path"; priority = 250; }
          ];

          formatting.format = ''
            function(entry, vim_item)
              local kind_icons = {
                Text = "", Method = "󰆧", Function = "󰊕", Constructor = "",
                Field = "󰇽", Variable = "󰂡", Class = "󰠱", Interface = "",
                Module = "", Property = "󰜢", Unit = "", Value = "󰎠",
                Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
                File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "",
                Constant = "󰏿", Struct = "", Event = "", Operator = "󰆕",
                TypeParameter = "󰅲",
              }
              vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              return vim_item
            end
          '';
        };
      };
    };
  };
}
