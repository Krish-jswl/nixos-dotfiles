return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float Terminal" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Vertical Terminal" },
    { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal Terminal" },
  },
  config = true,
}

