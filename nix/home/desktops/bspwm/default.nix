{ config, pkgs, ... }:

{
  imports = [
    ../../default.nix
  ];

  xsession.enable = true;
  xsession.windowManager.bspwm = {
    enable = true;
  };

  home.packages = with pkgs; [
    sxhkd
    polybar
    rofi
    feh
    betterlockscreen
    alacritty
  ];

  services = {
    dunst = import ../../modules/dunst.nix { inherit config; };
  };
}
