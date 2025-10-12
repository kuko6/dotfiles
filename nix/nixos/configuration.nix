# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  system.activationScripts.preActivation = ''
    if [[ -e /run/current-system ]]; then
      echo "--- diff to current-system"
      # ${pkgs.nix}/bin/nix store diff-closures --verbose /run/current-system "$systemConfig"
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
      echo "---"
    fi
  '';
  
  # System Configuration
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };
  nixpkgs.config.allowUnfree = true;

  # Boot Configuration
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };
  # boot.loader.grub.configurationLimit = 10;

  # Display and Window Management
  services.displayManager = {
    enable = true;
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha";
      package = pkgs.kdePackages.sddm;
    };
    defaultSession = "river";
  };

  # For Gnome
  # services.xserver = {
  #   enable = true;
  #   displayManager.gdm.enable = true;
  #   displayManager.gdm.wayland = true;
  #   desktopManager.gnome.enable = true;
  # };

  # environment.gnome.excludePackages = (with pkgs; [
  #   atomix # puzzle game
  #   cheese # webcam tool
  #   epiphany # web browser
  #   evince # document viewer
  #   geary # email reader
  #   gedit # text editor
  #   gnome-characters
  #   gnome-music
  #   gnome-photos
  #   gnome-terminal
  #   gnome-tour
  #   hitori # sudoku game
  #   iagno # go game
  #   tali # poker game
  #   totem # video player
  # ]);

  # Automatically adds `river.desktop` to `/usr/share/wayland-sessions/`
  programs.river.enable = true;

  # XDG Portal Configuration
  services.dbus.enable = true;
  hardware.graphics.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    # wlr.enable = true;
    # lxqt.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config = {
      common.default = [ "gtk" ];
      river.default = [ "wlr" "gtk" ];
    };
  };

  # For X11 (bspwm)
  # services.displayManager = {
  #   sddm = {
  #     enable = true;
  #     theme = "catppuccin-mocha";
  #     package = pkgs.kdePackages.sddm;
  #   };
  # };
  # services.xserver = {
  #   enable = true;
  #   windowManager.bspwm.enable = true;
  # };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22 ];
  };
  services.openssh.enable = true;

  # Localization
  time.timeZone = "Europe/Bratislava";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Input Configuration
  services.xserver.xkb = {
    layout = "gb";
    variant = "mac";
  };
  console.keyMap = "uk";

  # Audio Configuration
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;

  # User Configuration
  users = {
    defaultUserShell = pkgs.zsh;
    users.kuko = {
      isNormalUser = true;
      description = "kuko";
      extraGroups = [ "networkmanager" "wheel" ];
      # packages = with pkgs; [];
    };
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    vim
    git
    zsh
    curl
    nvd
    (catppuccin-sddm.override {
      flavor = "mocha";
      font = "Noto Sans";
      fontSize = "9";
    })
    pavucontrol # GUI volume control
    pulseaudio  # For pactl utility
    pamixer     # CLI volume control
  ];

  # Other System Services
  services = {
    printing.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;     # enables trash...
  };
  services.gnome.gnome-keyring.enable = true;
  
  # Programs
  programs = {
    dconf.enable = true;
    zsh.enable = true;
  };

  # System Maintenance
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";
}
