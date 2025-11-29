# Nix Config

## Install

Download nix:
```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```
or single-user install (I think it's better when using just the home-manager)
```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
```
add `experimental-features = nix-command flakes` to `/etc/nix/nix.conf`

Download home-manager:
```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager &&
nix-channel --update &&
nix-shell '<home-manager>' -A install
```

Clone this repo:
```sh
nix-shell -p git
```
```sh
git clone https://github.com/kuko6/dotfiles.git
```
on NixOS move `/etc/nixos/hardware-configuration.nix` into `nixos/`.

To apply NixOS config:
```sh
sudo nixos-rebuild switch --flake .#<config>
```

New packages should be declared in `~/nix/home-manager/`, to apply changes run:
```sh
home-manager switch --flake .#<config>
```

To update packages:
```sh
nix flake update
```

To list NixOS generations:
```sh
nixos-rebuild list-generations
```

Clearing garbage collector:
```sh
nix-collect-garbage
nix store gc
```
to also delete all older generations:
```sh
sudo nix-collect-garbage --delete-old
```

## Uninstall
[Uninstalling Nix](https://nix.dev/manual/nix/2.28/installation/uninstall.html)

## Troubleshooting
I sometimes had problems with [nix binaries not being in PATH](https://stackoverflow.com/a/78813750).

or add this to `.zshrc` or `.bashrc` or `.profile`:
```sh
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    . ~/.nix-profile/etc/profile.d/nix.sh
fi
```

## Ref
- [nix-starter-configs template](https://github.com/Misterio77/nix-starter-configs?tab=readme-ov-file)
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/introduction/)
- [Changing default shell on home-manager](https://discourse.nixos.org/t/using-home-manager-to-control-default-user-shell/8489/2)
- [Use Nix on Ubuntu](https://tech.aufomm.com/my-nix-journey-use-nix-with-ubuntu/)
- [How to Use Nix to Set Up Dev Environment](https://tech.aufomm.com/my-nix-journey-how-to-use-nix-to-set-up-dev-environment/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/#ch-configuration)
