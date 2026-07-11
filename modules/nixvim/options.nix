{ ... }:

{
  programs.nixvim = {

    globals = {
      mapleader = " ";
      netrw_banner = 0;
    };

    opts = {
      number = true;
      relativenumber = true;

      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      smartindent = true;

      wrap = true;

      mouse = "a";

      ignorecase = true;
      smartcase = true;

      termguicolors = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;

      undofile = true;
      swapfile = false;

      winblend = 0;
      pumblend = 10;
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

  };
}
