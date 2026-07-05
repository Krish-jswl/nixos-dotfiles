{ ... }:

{
  programs.nixvim.plugins.conform-nvim = {
    enable = true;

    settings = {
      formatters_by_ft = {
        lua = [ "stylua" ];

        nix = [ "nixfmt" ];

        c = [ "clang_format" ];
        cpp = [ "clang_format" ];

        go = [ "gofmt" ];

        rust = [ "rustfmt" ];

        python = [ "black" ];

        sh = [ "shfmt" ];

        javascript = [ "prettier" ];
        javascriptreact = [ "prettier" ];

        typescript = [ "prettier" ];
        typescriptreact = [ "prettier" ];

        json = [ "prettier" ];
        jsonc = [ "prettier" ];

        yaml = [ "prettier" ];

        html = [ "prettier" ];
        css = [ "prettier" ];

        markdown = [ "prettier" ];
      };
    };
  };
}
