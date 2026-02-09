{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        email = "imkrishjaiswal05@gmail.com";
        name = "Krish-jswl";
      };

      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = true;
    };

  };
}
