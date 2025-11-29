# River Setup

## minimal (no DE) Tumbleweed

Can’t get this one to work with river installed with nix, it has to be with zypper
```sh
sudo zypper refresh
sudo zypper update
```

Install dependencies
```sh
sudo zypper in river
```
- there might be something with wayland, but I dont remember what it was
- maybe `wlroots, wayland`

### Setting up Display Manager

```sh
sudo zypper in greetd gtkgreet cage
```

Edit `/etc/greetd/config.toml`
```toml
[terminal]
vt = 1

[default_session]
command = "cage gtkgreet"
user = "greeter"

[initial_session]
command = "river"
user = "kuko"
```

Enable the DM service
```
sudo systemctl enable greetd
```

Start the service
```
sudo systemctl start greetd
```

## Starting from Desktop Environment

Add `river.desktop` to `/usr/share/wayland-sessions/` with:
```
[Desktop Entry]
Name=River
Comment=Dynamic Wayland compositor
Exec=start-river
Type=Application
```

Move `desktops/river/start-river` to `/usr/local/bin`

<!--
## Ref

- [https://codeberg.org/river/river](https://codeberg.org/river/river)
- [https://github.com/Alexays/Waybar](https://github.com/Alexays/Waybar)
- [https://nix-community.github.io/home-manager/options.xhtml](https://nix-community.github.io/home-manager/options.xhtml)

---

- [https://github.com/CelestialCrafter/nixos-config](https://github.com/CelestialCrafter/nixos-config)
- [https://github.com/uncomfyhalomacro/river-paper-theme](https://github.com/uncomfyhalomacro/river-paper-theme)
- [https://git.sr.ht/~lown/dotfiles-nixos-river](https://git.sr.ht/~lown/dotfiles-nixos-river)
- [https://www.reddit.com/r/unixporn/comments/1dq3lv3/hyprland_surprisingly_easy_to_install_on_debian/](https://www.reddit.com/r/unixporn/comments/1dq3lv3/hyprland_surprisingly_easy_to_install_on_debian/)
-->
