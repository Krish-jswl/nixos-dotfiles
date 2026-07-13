{ ... }:

{
  imports = [
    ./options.nix
    ./autocmd.nix
    ./keymaps.nix
    ./theme.nix

    ./plugins/lsp.nix
    ./plugins/blink.nix
    ./plugins/luasnip.nix
    ./plugins/conform.nix
    ./plugins/telescope.nix
    ./plugins/toggle-term.nix
    ./plugins/lualine.nix
    ./plugins/gitsigns.nix
    ./plugins/comment.nix
    ./plugins/nvim-tree.nix
    ./plugins/colorizer.nix
    ./plugins/indent-blankline.nix
    ./plugins/mini-surround.nix
    ./plugins/treesitter.nix
    
    ./plugins/extra.nix
  ];

  programs.nixvim = {
    enable = true;
  };
}
