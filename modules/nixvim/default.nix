{ ... }:

{
  imports = [
    ./options.nix
    ./autocmd.nix
    ./keymaps.nix
    ./colorscheme.nix
  ];

  programs.nixvim = {
    enable = true;
  };
}
