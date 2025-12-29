vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

--tabs & indentations
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

opt.wrap = true
opt.linebreak = true
opt.scrolloff = 4

--search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

--themes
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

--backspace
opt.backspace = "indent,eol,start"

--clipboard
-- opt.clipboard:append("unnamedplus")
opt.clipboard = { 'unnamedplus', 'unnamed' }

--split windows
opt.splitright = true
opt.splitbelow = true

--disable mode show
opt.showmode = false
