{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    startAgent = true;

    extraConfig = ''
      AddKeysToAgent yes
      IdentityFile ~/.ssh/id_ed25519
      ServerAliveInterval 60
      ServerAliveCountMax 3
    '';
  };
}

