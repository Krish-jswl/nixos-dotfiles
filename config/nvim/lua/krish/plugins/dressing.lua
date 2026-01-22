return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = { enabled = true },
    select = {
      enabled = true,
      backend = { "telescope", "builtin" },
    },
  },
}

