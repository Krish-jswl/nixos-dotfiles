{ ... }:

{
  programs.nixvim.autoCmd = [
    {
      event = "TextYankPost";
      desc = "Highlight yanked text";
      callback = {
        __raw = "function() vim.hl.on_yank() end";
      };
    }

    {
      event = "FileType";
      pattern = [ "go" ];

      callback.__raw = ''
        function()
          vim.bo.expandtab = false
        end
      '';
    }

    {
      event = "FileType";
      pattern = [
        "lua"
        "nix"
        "json"
        "jsonc"
        "yaml"
        "html"
        "css"
        "javascript"
        "typescript"
        "javascriptreact"
        "typescriptreact"
        "markdown"
      ];

      callback.__raw = ''
        function()
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.softtabstop = 2
        end
      '';
    }
  ];
}
