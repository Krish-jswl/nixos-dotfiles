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
      completeopt = [
        "menuone"
        "noselect"
        "fuzzy"
        "nosort"
      ];
      colorcolumn = "";
      signcolumn = "yes";
      cmdheight = 0;
      termguicolors = true;
      scrolloff = 4;
      cursorline = true;
      pumblend = 10;
      winblend = 0;
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

      {
        event = "FileType";
        pattern = [
          "c"
          "cpp"
        ];
        callback.__raw = ''
          function()
            vim.bo.expandtab = true
            vim.bo.tabstop = 4
            vim.bo.shiftwidth = 4
            vim.bo.softtabstop = 4
          end
        '';
      }

      {
        event = "FileType";
        pattern = [ "go" ];
        callback.__raw = ''
          function()
            vim.bo.expandtab = false
            vim.bo.tabstop = 4
            vim.bo.shiftwidth = 4
            vim.bo.softtabstop = 4
          end
        '';
      }

      {
        event = "FileType";
        pattern = [
          "rust"
          "python"
          "sh"
          "bash"
        ];
        callback.__raw = ''
          function()
            vim.bo.expandtab = true
            vim.bo.tabstop = 4
            vim.bo.shiftwidth = 4
            vim.bo.softtabstop = 4
          end
        '';
      }

      {
        event = "FileType";
        pattern = [
          "lua"
          "nix"
          "html"
          "css"
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
          "json"
          "jsonc"
          "yaml"
          "markdown"
        ];
        callback.__raw = ''
          function()
            vim.bo.expandtab = true
            vim.bo.tabstop = 2
            vim.bo.shiftwidth = 2
            vim.bo.softtabstop = 2
          end
        '';
      }
    ];

    # =========================================================================
    # KEYMAPS (ALL COMBINED)
    # =========================================================================
    keymaps = [
      # Normal Mode
      {
        mode = "n";
        key = "<leader>nh";
        action = "<cmd>nohl<CR>";
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
        mode = "n";
        key = "<leader>u";
        action = "<cmd>UndotreeToggle<CR>";
        options.desc = "Toggle Undotree";
      }
      # Plugin Toggles
      {
        mode = "n";
        key = "<leader>ee";
        action = "<cmd>NvimTreeToggle<CR>";
        options.desc = "Toggle file explorer";
      }
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>ToggleTerm<CR>";
        options.desc = "Toggle terminal";
      }
      {
        mode = "n";
        key = "<leader>tv";
        action = "<cmd>ToggleTerm direction=vertical<CR>";
        options.desc = "Float terminal";
      }
      {
        mode = "t";
        key = "<Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
      }

      # Visual Mode
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

      # cmp extra
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

      # snippet
      {
        mode = [
          "i"
          "s"
        ];
        key = "<C-j>";

        action.__raw = ''
          function()
            local ls = require("luasnip")
            if ls.choice_active() then
              ls.change_choice(1)
            end
          end
        '';
      }
    ];

    # =========================================================================
    # CUSTOM PLUGINS & THEME
    # =========================================================================

    extraConfigLua = ''
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

      -- DIAGNOSTICS

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
      -----

      --- Doc Border
        vim.lsp.handlers["textDocument/hover"] =
          vim.lsp.with(
            vim.lsp.handlers.hover,
            {
              border = "rounded",
            }
          )

        vim.lsp.handlers["textDocument/signatureHelp"] =
          vim.lsp.with(
            vim.lsp.handlers.signature_help,
            {
              border = "rounded",
            }
          )

      ---

    '';

    # =========================================================================
    # COLORSCHEME
    # =========================================================================
    colorschemes = {
      everforest = {
        enable = true;

        settings = {
          background = "hard";
          transparent_background = 1;
          disable_italic_comment = 0;
          better_performance = true;
        };
      };
    };

    # =========================================================================
    # PLUGINS
    # =========================================================================
    plugins = {

      lualine = {
        enable = true;

        settings = {
          options = {
            theme = "everforest";
            globalstatus = true;
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

      toggleterm = {
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

      nvim-autopairs.enable = true;

      web-devicons.enable = true;
      undotree.enable = true;

      colorizer = {
        enable = true;
        settings.user_default_options = {
          RGB = true;
          RRGGBB = true;
          RRGGBBAA = true;
          AARRGGBB = true;
          names = true;
          rgb_fn = true;
          hsl_fn = true;
          css = true;
          css_fn = true;
          tailwind = true;
          mode = "background";
        };
      };

      nvim-tree = {
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
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            options.desc = "Find files";
          };
          "<leader>fs" = {
            action = "live_grep";
            options.desc = "Live grep";
          };
          "<leader>fb" = {
            action = "buffers";
            options.desc = "Buffers";
          };
          "<leader>fh" = {
            action = "help_tags";
            options.desc = "Help tags";
          };
          "<leader>fd" = {
            action = "diagnostics";
            options.desc = "Diagnostics";
          };

          "<leader>fr" = {
            action = "lsp_references";
            options.desc = "LSP references";
          };

          "<leader>fi" = {
            action = "lsp_implementations";
            options.desc = "LSP implementations";
          };

          "<leader>ft" = {
            action = "lsp_type_definitions";
            options.desc = "LSP type definitions";
          };

          "<leader>fsd" = {
            action = "lsp_document_symbols";
            options.desc = "Document symbols";
          };
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
            "df" = {
              action = "open_float";
              desc = "Line diagnostics";
            };
            "[d" = {
              action = "goto_prev";
              desc = "Previous diagnostic";
            };
            "]d" = {
              action = "goto_next";
              desc = "Next diagnostic";
            };
          };
          lspBuf = {
            "gd" = {
              action = "definition";
            };
            "gD" = {
              action = "declaration";
            };
            "gi" = {
              action = "implementation";
            };
            "gr" = {
              action = "references";
            };
            "gt" = {
              action = "type_definition";
            };

            "K" = {
              action = "hover";
            };

            "<leader>rn" = {
              action = "rename";
            };
            "<leader>ca" = {
              action = "code_action";
            };

          };
        };

        servers = {
          lua_ls.enable = true;
          marksman.enable = true;
          gopls.enable = true;
          pyright.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
            settings = {
              cargo.allFeatures = true;
              check.command = "clippy";
            };
          };
          clangd = {
            enable = true;
            cmd = [
              "clangd"
              "--offset-encoding=utf-16"
            ];
          };
          ts_ls = {
            enable = true;

            settings = {
              javascript = {
                suggest = {
                  completeFunctionCalls = true;
                  autoImports = true;
                };
              };

              typescript = {
                suggest = {
                  completeFunctionCalls = true;
                  autoImports = true;
                };
              };
            };
          };
          html.enable = true;
          cssls.enable = true;
          tailwindcss.enable = true;
          jsonls.enable = true;
          nixd.enable = true;
          yamlls.enable = true;
          bashls.enable = true;
        };
      };
      conform-nvim = {
        enable = true;

        settings = {
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };

          formatters_by_ft = {
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];

            javascript = [ "prettier" ];
            javascriptreact = [ "prettier" ];

            typescript = [ "prettier" ];
            typescriptreact = [ "prettier" ];

            json = [ "prettier" ];
            jsonc = [ "prettier" ];
            yaml = [ "prettier" ];
            html = [ "prettier" ];
            css = [ "prettier" ];

            markdown = [ "prettier" ];

            python = [ "black" ];

            go = [ "gofmt" ];

            rust = [ "rustfmt" ];

            c = [ "clang_format" ];
            cpp = [ "clang_format" ];

            sh = [ "shfmt" ];
          };
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

      cmp-nvim-lsp.enable = true;
      cmp = {
        enable = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          completion.completeopt = "menu,menuone,noselect";

          window = {
            completion = {
              border = "rounded";
            };
            documentation = {
              border = "rounded";
            };
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
            {
              name = "nvim_lsp";
              priority = 1000;
            }
            {
              name = "luasnip";
              priority = 750;
            }
            {
              name = "buffer";
              priority = 500;
            }
            {
              name = "path";
              priority = 250;
            }
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
