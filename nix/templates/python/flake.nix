{
  description = "Simple Python development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let
      supportedSystems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems
        (system: f { pkgs = import nixpkgs { inherit system; }; });
    in {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          venvDir = ".venv";
          packages = with pkgs;
            [ python3 ]
            ++ (with pkgs.python3Packages; [ pip venvShellHook ruff pyright ])
            ++ [ stdenv.cc.cc pythonManylinuxPackages.manylinux2014Package ];
          # shellHook = ''
          #   export LD_LIBRARY_PATH=${
          #     pkgs.lib.makeLibraryPath [
          #       pkgs.stdenv.cc.cc
          #       pkgs.pythonManylinuxPackages.manylinux2014Package
          #     ]
          #   }:$LD_LIBRARY_PATH
          # '';
        };
      });
    };
}
