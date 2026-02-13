return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,        -- make sure to load this before all the other start plugins
    config = function()
      require("gruvbox").setup({
        contrast = "soft",           -- "hard", "soft" or empty/"medium" (default)

        -- Main transparency setting
        transparent_mode = true,

        -- Nice extras (optional but recommended)
        terminal_colors = true,      -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        inverse = true,              -- invert background for search, diffs, statuslines etc.
        dim_inactive = false,
        -- You can also override specific highlights here if needed
        -- overrides = {},
      })

      -- Very important: setup() → then colorscheme
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
    end,
  },
}
