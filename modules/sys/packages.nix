{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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
