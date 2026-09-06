# Zoom In/Out

macOS-style **text zoom** for [Omarchy](https://omarchy.org/) (Hyprland): Super together with `+` zooms the focused app in, Super together with `-` zooms it out. Browsers get page zoom; terminals get font-size zoom. This is **not** the accessibility screen magnifier (`SUPER + CTRL + Z` on stock Omarchy).

Plugin id: `io.github.2dennis.zoom-in-out`  
Kind: `service` (headless; no bar widget)

## Install

Omarchy clones the git repo, validates `manifest.json`, and never runs install hooks. Enabling the plugin loads `Service.qml`, which registers Lua Hyprland binds (`hyprctl eval` + a `dofile` line in `~/.config/hypr/bindings.lua`). Old `bindd` keywords do nothing on Omarchy Quattro / Hyprland 0.55.

Update an existing install:

```sh
omarchy plugin update io.github.2dennis.zoom-in-out
omarchy-shell shell rescanPlugins
```

Then disable and enable the plugin (or restart the shell) so binds reinstall.

```sh
omarchy plugin add https://github.com/2Dennis/zoom-in-out.git --enable
```

Until the repo is public, copy it by hand:

```sh
git clone https://github.com/2Dennis/zoom-in-out.git \
  ~/.config/omarchy/plugins/io.github.2dennis.zoom-in-out
omarchy-shell shell rescanPlugins
omarchy plugin enable io.github.2dennis.zoom-in-out
```

Confirm:

```sh
omarchy plugin list --json | jq '.[] | select(.id == "io.github.2dennis.zoom-in-out")'
```

## Remove

```sh
omarchy plugin remove io.github.2dennis.zoom-in-out
```

If an older install used id `2Dennis.zoom-in-out`, remove that first (marketplace ids must be lowercase):

```sh
omarchy plugin remove 2Dennis.zoom-in-out
omarchy plugin add https://github.com/2Dennis/zoom-in-out.git --enable
```

## Keybindings

US keyboard: `+` is Shift+Equal. Both Equal and Shift+Equal are bound for zoom in.

| Shortcut | Action |
| --- | --- |
| `SUPER` + `=` | Zoom in (macOS Cmd+=) |
| `SUPER` + `Shift` + `=` (`SUPER` + `+`) | Zoom in (macOS Cmd++) |
| `SUPER` + `-` | Zoom out |
| `SUPER` + `Shift` + `-` | Zoom out |
| `SUPER` + `CTRL` + `0` | Reset zoom |

Binds use the same evdev keycodes Omarchy uses (`code:20` minus, `code:21` equal, `code:19` zero) so they follow the physical keys on other layouts the way stock resize did.

CLI / IPC (after enable):

```sh
~/.config/omarchy/plugins/io.github.2dennis.zoom-in-out/bin/omarchy-zoom in
~/.config/omarchy/plugins/io.github.2dennis.zoom-in-out/bin/omarchy-zoom out
~/.config/omarchy/plugins/io.github.2dennis.zoom-in-out/bin/omarchy-zoom reset

omarchy-shell zoom-in-out zoomIn
omarchy-shell zoom-in-out zoomOut
omarchy-shell zoom-in-out reset
```

## How zoom is dispatched

The script reads `hyprctl activewindow` and sends a shortcut to the focused client with Hyprland `sendshortcut` (no `wtype` / `ydotool`; Hyprland already ships this).

| Focused `class` (lowercase) | In | Out | Reset |
| --- | --- | --- | --- |
| Browsers: Firefox, LibreWolf, Floorp, Zen, Chrome, Chromium, Brave, Vivaldi, Opera, Edge, Thorium, … | Ctrl+= | Ctrl+- | Ctrl+0 |
| Ghostty, Alacritty, GNOME Terminal, Ptyxis, Tilix, Konsole, xfce4-terminal, Terminator, Console | Ctrl++ / Ctrl+= | Ctrl+- | Ctrl+0 |
| foot (Omarchy default) | Ctrl++ | Ctrl+- | Ctrl+0 |
| Kitty | Ctrl+Shift+= | Ctrl+Shift+- | Ctrl+Shift+Backspace |
| WezTerm | Ctrl+Shift+= | Ctrl+Shift+- | Ctrl+Shift+0 |
| Everything else (VS Code, editors, …) | Ctrl+= | Ctrl+- | Ctrl+0 |

Linux browsers zoom with Ctrl, not Super; the plugin translates Super++ into that app shortcut, matching Cmd++ on macOS.

## Conflicts with stock Omarchy

| Stock bind | What it did | This plugin |
| --- | --- | --- |
| `SUPER` + minus / equal (`code:20` / `code:21`) | Resize window horizontally | **Replaced** by zoom out / zoom in |
| `SUPER` + Shift + minus / equal | Resize window vertically | **Replaced** by zoom out / zoom in |
| `SUPER` + Alt + minus / equal | Smaller resize | **Unchanged** — keep using this for keyboard resize |
| `SUPER` + Ctrl + minus / equal | Larger resize | **Unchanged** |
| `SUPER` + `0` | Workspace 10 | **Not stolen.** Reset is Super+Ctrl+0 instead |
| `SUPER` + Ctrl + `Z` | Cursor / screen zoom factor | **Unchanged** (magnifier stays on its own chord) |

If you still want Super++ for window resize, do not enable this plugin.

## Optional Hyprland snippet

If you are not on Omarchy Quattro’s shell plugins, you can source `hypr/zoom-in-out.conf` after unbinding the resize keys. The service path above is the supported install.
