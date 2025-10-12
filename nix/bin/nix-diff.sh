#!/bin/sh

prev_gen=$(ls -dv /nix/var/nix/profiles/system-*-link | tail -n 2 | head -n 1)

# nix store diff-closures --verbose /run/current-system $(realpath $prev_gen) # native nix version
nvd diff /run/current-system $(realpath $prev_gen)
