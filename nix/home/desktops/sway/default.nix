{ config, pkgs, ... }:

{
  imports = [
    ../../default.nix
  ];

  xdg = {
    enable = true;
    # will be in ~/.config/xdg-desktop-portals/
    portal = {
      config = {
        common.default = "gtk";
        sway.default = ["wlr" "gtk"];
      };
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
      enable = true;
    };
  };

  wayland.windowManager.sway = {
    enable = true;
  };

  home.packages = with pkgs; [
    foot
    fuzzel
    swaybg
    waybar

    # nautilus
    # qimgv
  ];

   home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    GTK_USE_PORTAL = 1;
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = 1;
  };

  services = {
    dunst = import ../../modules/dunst.nix { inherit config; };
  };
}
