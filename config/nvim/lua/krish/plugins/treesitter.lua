return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
          },
        },
      },

      highlight = { enable = true },
      indent = { enable = true },
      autotag = { enable = true },

      ensure_installed = {
        "json", "python", "javascript", "query",
        "typescript", "tsx", "php", "yaml",
        "html", "css", "markdown", "markdown_inline",
        "bash", "lua", "vim", "vimdoc",
        "c", "dockerfile", "gitignore", "astro",
      },

      auto_install = false,
    },
  },
}

