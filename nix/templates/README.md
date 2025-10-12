Get the template:
```
# Initialize in the current project
nix flake init --template github:kuko6/nix-config/main#lang

# Create a new project
nix flake new --template github:kuko6/nix-config/main#lang ./new-project-dir
```

Run the dev env:
```
nix develop -c $SHELL
```
