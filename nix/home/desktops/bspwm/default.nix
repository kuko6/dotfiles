{ config, pkgs, ... }:

{
  imports = [
    ../../default.nix
  ];

  xsession.windowManager.bspwm = {
    enable = true;
  };

  home.packages = with pkgs; [
    sxhkd
    polybar
    rofi
    feh
    betterlockscreen
  ];
}
