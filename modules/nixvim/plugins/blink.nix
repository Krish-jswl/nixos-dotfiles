{ ... }:

{
  programs.nixvim.plugins.blink-cmp = {
    enable = true;

    settings = {
      appearance = {
        nerd_font_variant = "mono";
      };

      completion = {
        menu = {
          border = "rounded";
        };
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
        };
      };

      keymap = {
        preset = "none";

        "<Tab>" = [
          "select_next"
          "fallback"
        ];

        "<S-Tab>" = [
          "select_prev"
          "fallback"
        ];

        "<CR>" = [
          "accept"
          "fallback"
        ];

        "<C-e>" = [ "hide" ];

        "<C-n>" = [ "select_next" ];
        "<C-p>" = [ "select_prev" ];
      };

      signature = {
        enabled = true;
      };

      sources = {
        default = [
          "lsp"
          "path"
          "buffer"
          "snippets"
        ];
      };
    };
  };
}
