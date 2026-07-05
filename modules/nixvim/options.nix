{ ... }:

{
  programs.nixvim.opts = {
    number = true;
    relativenumber = true;

    tabstop = 4;
    shiftwidth = 4;
    expandtab = true;
    smartindent = true;

    wrap = false;

    mouse = "a";

    ignorecase = true;
    smartcase = true;

    termguicolors = true;
    signcolumn = "yes";
    cursorline = true;
    scrolloff = 8;

    undofile = true;
    swapfile = false;
  };
}
