return {
    {
        "saghen/blink.compat",
        version = "*",
        lazy = true,
        opts = {},
    },
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "moyiz/blink-emoji.nvim",
            "ray-x/cmp-sql",
        },

        opts = {
            ------------------------------------------------------------------
            -- KEYMAPS
            ------------------------------------------------------------------
            keymap = {
                preset = "default",

                ["<Tab>"] = { "accept", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },

                ["<Up>"] = false,
                ["<Down>"] = false,
            },

            ------------------------------------------------------------------
            -- APPEARANCE
            ------------------------------------------------------------------
            appearance = {
                nerd_font_variant = "mono",
            },

            ------------------------------------------------------------------
            -- COMPLETION UI
            ------------------------------------------------------------------
            completion = {
                menu = {
                    border = "rounded",
                    winblend = 0,
                    scrollbar = false,
                },
                documentation = {
                    auto_show = true,
                },
            },

            ------------------------------------------------------------------
            -- SIGNATURE HELP
            ------------------------------------------------------------------
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },

            ------------------------------------------------------------------
            -- SOURCES
            ------------------------------------------------------------------
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "emoji", "sql" },

                providers = {
                    emoji = {
                        name = "Emoji",
                        module = "blink-emoji",
                        score_offset = 15,
                        opts = { insert = true },
                        should_show_items = function()
                            return vim.tbl_contains({ "gitcommit", "markdown" }, vim.bo.filetype)
                        end,
                    },

                    sql = {
                        name = "sql",
                        module = "blink.compat.source",
                        score_offset = -3,
                        opts = {},
                        should_show_items = function()
                            return vim.bo.filetype == "sql"
                        end,
                    },
                },
            },

            ------------------------------------------------------------------
            -- FUZZY
            ------------------------------------------------------------------
            fuzzy = {
                implementation = "prefer_rust_with_warning",
            },
        },

        opts_extend = { "sources.default" },

        ----------------------------------------------------------------------
        -- NORD HIGHLIGHTS (MINIMAL, CLEAN)
        ----------------------------------------------------------------------
        config = function(_, opts)
            require("blink.cmp").setup(opts)

            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "nord",
                callback = function()
                    local c = {
                        bg      = "#2E3440",
                        bg_dark = "#242933",
                        fg      = "#D8DEE9",
                        dim     = "#AEB4C2",
                        blue    = "#81A1C1",
                        cyan    = "#88C0D0",
                        green   = "#A3BE8C",
                        yellow  = "#EBCB8B",
                        purple  = "#B48EAD",
                    }

                    local hl = vim.api.nvim_set_hl

                    -- menu
                    hl(0, "BlinkCmpMenu",       { bg = c.bg_dark })
                    hl(0, "BlinkCmpMenuBorder", { fg = c.blue, bg = c.bg_dark })

                    -- selection
                    hl(0, "BlinkCmpMenuSelection", {
                        bg = c.blue,
                        fg = c.bg_dark,
                        bold = true,
                    })

                    -- labels
                    hl(0, "BlinkCmpLabel",      { fg = c.fg })
                    hl(0, "BlinkCmpLabelMatch", { fg = c.cyan, bold = true })
                    hl(0, "BlinkCmpSource",     { fg = c.dim, italic = true })

                    -- kinds (minimal color, nord-style)
                    hl(0, "BlinkCmpKindFunction", { fg = c.blue })
                    hl(0, "BlinkCmpKindVariable", { fg = c.fg })
                    hl(0, "BlinkCmpKindClass",    { fg = c.yellow })
                    hl(0, "BlinkCmpKindKeyword",  { fg = c.purple })
                    hl(0, "BlinkCmpKindSnippet",  { fg = c.green })

                    -- docs
                    hl(0, "BlinkCmpDoc",       { bg = c.bg_dark })
                    hl(0, "BlinkCmpDocBorder", { fg = c.blue, bg = c.bg_dark })
                end,
            })
        end,
    },
}

