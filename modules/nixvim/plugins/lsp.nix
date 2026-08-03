{ ... }:

{
  programs.nixvim.plugins.lsp = {
    enable = true;

    servers = {
      # C / C++
      clangd.enable = true;

      # Go
      gopls = {
        enable = true;

        filetypes = [
          "go"
          "gomod"
          "gosum"
          "gotmpl"
          "gohtmltmpl"
          "gotexttmpl"
        ];

        settings = {
          gopls = {
            analyses = {
              unusedparams = true;
            };
            staticcheck = true;
            fileWatcher = "fsnotify";
          };
        };
      };

      # Rust
      rust_analyzer = {
        enable = true;

        installCargo = false;
        installRustc = false;

        settings = {
          cargo.allFeatures = true;
          check.command = "clippy";
        };
      };

      # Nix
      nixd.enable = true;

      # Lua
      lua_ls.enable = true;

      # Python
      pyright.enable = true;

      # Bash
      bashls.enable = true;

      # Markdown
      marksman.enable = true;

      # Docker
      dockerls.enable = true;
      docker_compose_language_service.enable = true;

      # Frontend
      html.enable = true;
      cssls.enable = true;
      ts_ls.enable = true;
      jsonls.enable = true;
      yamlls.enable = true;
    };
  };
}
