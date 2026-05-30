vim.g.mapleader = " "

vim.keymap.set("n", "<leader>nh", ":nohl<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move lines down in visual mode"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move lines up in visual mode"})

vim.keymap.set("n", "<", "<gv", { desc = "Unindent and keep selction" })
vim.keymap.set("n", ">", ">gv", { desc = "Indent and keep selction" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result cursor centered" })

-- native undotree
vim.keymap.set("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })
