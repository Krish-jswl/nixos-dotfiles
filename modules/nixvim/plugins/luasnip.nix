{ ... }:

{
  programs.nixvim.plugins = {
    luasnip = {
      enable = true;

      settings = {
        history = true;
        update_events = "TextChanged,TextChangedI";
      };
    };

    friendly-snippets.enable = true;
  };
}
