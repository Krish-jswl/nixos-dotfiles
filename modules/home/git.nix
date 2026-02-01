{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "Krish-jswl";
    userEmail = "imkrishjaiswal05@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = true;
    };
  };
}
