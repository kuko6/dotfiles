{ config, lib, pkgs, ... }:

{
  home.username = "kuko";
  home.homeDirectory = "/home/kuko";

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  home.activation = {
    test = lib.hm.dag.entryAfter ["writeBoundary"] ''
      nix profile diff-closures --verbose --profile ~/.local/state/nix/profiles/home-manager
    '';
  };

  # home.activation = {
  #   showLatestDiff = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #     home-manager generations \
  #       | head -n2 \
  #       | awk '
  #           NR==1 { new=$7 }
  #           NR==2 { old=$7 }
  #           END {
  #             printf("Changes from %s → %s\n", old, new)
  #             system("nvd diff " old " " new)
  #           }
  #         '
  #   '';
  # };

  home.file = {
    "${config.xdg.configHome}" = {
      source = ../dotfiles;
      recursive = true;
    };
    ".local/bin" = {
      source = ../bin;
      recursive = true;
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
   enable = true;
   #  theme = {
   #    name = "catppuccin-mocha-lavender-compact+normal";
   #     package = pkgs.catppuccin-gtk.override {
   #     accents = [ "lavender" ];
   #     size = "compact";
   #     tweaks = [ "normal" ];
   #     variant = "mocha";
   #   };
   # };
   # iconTheme = {
   #   name = "Papirus";
   #   package = pkgs.papirus-icon-theme;
   # };
   # cursorTheme = {
   #   name = "macOS";
   #   package = pkgs.apple-cursor;
   #   size = 24;
   # };
  };

  # Creates common user directories
  # xdg.userDirs = {
  #   enable = true;
  #   createDirectories = true;
  #   templates = null;
  #   publicShare = null;
  #   extraConfig = {
  #     XDG_DEVELOPER_DIR = "${config.home.homeDirectory}/Developer";
  #   };
  # };

  # Packages installed to the user profile
  # packages doesnt need to be here if they are included in programs
  home.packages = with pkgs; [
    starship
    fastfetch
    yazi
    tmux
    helix
    btop
    tree
    nvd
    vim
    cbonsai
    playerctl

    # Fonts
    departure-mono
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    material-icons
    material-symbols
  ];

  # services.snapd.enable = false;

  programs.git = {
    enable = true;
    userName = "Jakub Povinec";
    userEmail = "jakub.povinec@gmail.com";
    extraConfig = { init = { defaultBranch = "main"; }; };
  };

  programs = {
    zsh = import ./modules/zsh.nix { inherit config pkgs; };
  };

  services = {
    dunst = import ./modules/dunst.nix { inherit config; };
  };

  programs.home-manager.enable = true;
}
