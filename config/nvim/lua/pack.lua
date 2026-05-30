vim.pack.add({
    -- theme
    "https://github.com/sainnhe/gruvbox-material",

    -- utility
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",

    -- file explorer
    "https://github.com/nvim-tree/nvim-tree.lua",

    -- telescope
    "https://github.com/nvim-telescope/telescope.nvim",

    -- treesitter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },

    -- lsp
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",

    -- completion
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-buffer",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/saadparwaiz1/cmp_luasnip",

    -- snippets
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/rafamadriz/friendly-snippets",
    -- colorizer
    "https://github.com/NvChad/nvim-colorizer.lua",
})

--------------------------------------------------
-- colorscheme
--------------------------------------------------

vim.cmd.packadd("gruvbox-material")

vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_enable_italic = true

vim.cmd.colorscheme("gruvbox-material")

--------------------------------------------------
-- nvim-tree
--------------------------------------------------

require("nvim-tree").setup({
    view = {
        width = 30,
    },

    renderer = {
        group_empty = true,
    },

    filters = {
        dotfiles = false,
    },
})

vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", {
    desc = "Toggle file explorer",
})

--------------------------------------------------
-- telescope
--------------------------------------------------

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>.", builtin.find_files, {
    desc = "Find files",
})

vim.keymap.set("n", "<leader>fs", builtin.live_grep, {
    desc = "Live grep",
})

vim.keymap.set("n", "<leader>,", builtin.buffers, {
    desc = "Buffers",
})

vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
    desc = "Help tags",
})

vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {
    desc = "Diagnostics",
})

--------------------------------------------------
-- colorizer
--------------------------------------------------

require("colorizer").setup({
    user_default_options = {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        names = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        tailwind = true,

        mode = "background",
    },
})

--------------------------------------------------
-- luasnip
--------------------------------------------------

local luasnip = require("luasnip")

-- Load VSCode-like snippets (from friendly-snippets)
require("luasnip.loaders.from_vscode").lazy_load()

-- Update LuaSnip config to prevent jumping back to old snippets
luasnip.config.setup({
    history = false, 
    update_events = "TextChanged,TextChangedI",
})

--------------------------------------------------
-- nvim-cmp
--------------------------------------------------

local cmp = require("cmp")

-- (Optional) Define icons for the completion menu UI
local kind_icons = {
    Text = "", Method = "󰆧", Function = "󰊕", Constructor = "",
    Field = "󰇽", Variable = "󰂡", Class = "󰠱", Interface = "",
    Module = "", Property = "󰜢", Unit = "", Value = "󰎠",
    Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
    File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "",
    Constant = "󰏿", Struct = "", Event = "", Operator = "󰆕",
    TypeParameter = "󰅲",
}

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    completion = {
        completeopt = "menu,menuone,noselect",
    },

    -- 1. ADD BORDERS to your completion menus
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    -- 2. ADD UI FORMATTING (Icons and Source Tags)
    formatting = {
        format = function(entry, vim_item)
            -- Add the icon 
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)
            -- Append the source name to the menu
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
        end
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(), -- Handy way to close the menu
        
        -- 3. SAFER ENTER KEY: Require explicit selection
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false, -- Only confirm if you explicitly selected an item
        }),

        -- 4. FIX NAVIGATION: Restore default Vim completion navigation
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),

        -- 5. SUPER-TAB LOGIC
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            -- Use `locally_jumpable` to prevent jumping to snippets outside your current context
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),

    -- 6. ADD PRIORITIES to sources
    sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
    }),
})

--------------------------------------------------
-- treesitter
--------------------------------------------------

require("treesitter")

--------------------------------------------------
-- lsp
--------------------------------------------------

require("lsp")

