{ pkgs, ... }:

{
  users.users.krishj = {
    isNormalUser = true;
    shell = pkgs.zsh;

    extraGroups = [
      "wheel"
      "docker"
      "video"
      "networkmanager"
    ];

    packages = with pkgs; [
      tree
    ];
  };
}
