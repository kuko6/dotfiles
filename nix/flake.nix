{
  description = "My Nix Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;

      # Import Nix libraries
      lib = nixpkgs.lib // home-manager.lib;

      # Define supported systems
      systems = [ "x86_64-linux" "aarch64-linux" ];

      # Generate pkgs for each system
      pkgsFor = lib.genAttrs systems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );

    in {
      # NixOS configurations
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.kuko = import ./home/desktops/river;  # or bspwm or gnome
            }
          ];
        };
      };

      # Home-manager configurations
      homeConfigurations = {
        arm = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.aarch64-linux;
          modules = [
            ./home/desktops/gnome
          ];
        };

        x86 = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          modules = [
            ./home/desktops/gnome
          ];
        };
      };

      # Templates (for development environments)
      templates = {
        python = {
          description = "A simple python template";
          path = ./templates/python;
        };
      };
    };
}
