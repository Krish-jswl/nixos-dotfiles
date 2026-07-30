{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    mesa-demos
    man-pages
    man-pages-posix
    powertop
    pciutils
    efibootmgr
  ];
}
