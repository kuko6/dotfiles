## Setup
Add `sway.desktop` to `/usr/share/wayland-sessions/` with:

# add --unsupported-gpu for nvidia GPUs

```
[Desktop Entry]
Name=Sway
Comment=An i3-compatible Wayland compositor
Exec=sway --unsupported-gpu
Type=Application
DesktopNames=sway;wlroots
```
