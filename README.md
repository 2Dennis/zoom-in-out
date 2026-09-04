# Zoom In/Out

macOS-style **text zoom** for [Omarchy](https://omarchy.org/) (Hyprland): Super together with `+` zooms the focused app in, Super together with `-` zooms it out. Browsers get page zoom; terminals get font-size zoom. This is **not** the accessibility screen magnifier (`SUPER + CTRL + Z` on stock Omarchy).

Plugin id: `2Dennis.zoom-in-out`  
Kind: `service` (headless; no bar widget)

## Install

Omarchy clones the git repo, validates `manifest.json`, and never runs install hooks. Enabling the plugin loads `Service.qml`, which registers the Hyprland keybinds.

```sh
omarchy plugin add https://github.com/2Dennis/zoom-in-out.git --enable
```

Until the repo is public, copy it by hand:

```sh
git clone https://github.com/2Dennis/zoom-in-out.git \
  ~/.config/omarchy/plugins/2Dennis.zoom-in-out
omarchy-shell shell rescanPlugins
omarchy plugin enable 2Dennis.zoom-in-out
```

Confirm:

```sh
omarchy plugin list --json | jq '.[] | select(.id == "2Dennis.zoom-in-out")'
```

## Remove

```sh
omarchy plugin remove 2Dennis.zoom-in-out
```

Disabling or unloading the service unbinds Super++ / Super+- and restores Omarchy’s default window-resize binds on minus/equal.

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
~/.config/omarchy/plugins/2Dennis.zoom-in-out/bin/omarchy-zoom in
~/.config/omarchy/plugins/2Dennis.zoom-in-out/bin/omarchy-zoom out
~/.config/omarchy/plugins/2Dennis.zoom-in-out/bin/omarchy-zoom reset

omarchy-shell zoom-in-out zoomIn
omarchy-shell zoom-in-out zoomOut
omarchy-shell zoom-in-out reset
```

## How zoom is dispatched

The script reads `hyprctl activewindow` and sends a shortcut to the focused client with Hyprland `sendshortcut` (no `wtype` / `ydotool`; Hyprland already ships this).

| Focused `class` (lowercase) | In | Out | Reset |
| --- | --- | --- | --- |
| Browsers: Firefox, LibreWolf, Floorp, Zen, Chrome, Chromium, Brave, Vivaldi, Opera, Edge, Thorium, … | Ctrl+= | Ctrl+- | Ctrl+0 |
| Ghostty, Alacritty, foot, GNOME Terminal, Ptyxis, Tilix, Konsole, xfce4-terminal, Terminator, Console | Ctrl+= | Ctrl+- | Ctrl+0 |
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

## Limitations

- **Wayland key injection:** `sendshortcut` is compositor-side and is the reliable path on Hyprland. Apps that ignore Ctrl++ (custom keymaps, some Electron builds, remote desktops, nested VMs) will not zoom.
- **No focused window:** nothing happens.
- **Kitty / WezTerm:** font size uses Ctrl+Shift, not Ctrl. If you remapped those terminals, this plugin will not know.
- **Apps without text zoom:** the fallback still sends Ctrl+= / Ctrl+-; that may do nothing or trigger an unrelated command.
- **Not a screen magnifier:** whole-desktop zoom remains `SUPER + CTRL + Z` / `SUPER + CTRL + ALT + Z`.
- **`SUPER` + `0`:** not bound; that is workspace 10 on Omarchy.

## Publish to plugins.omarchy.org

This tree is the plugin. It is **not listed** on the marketplace until you:

1. Push a **public GitHub repository** with `manifest.json` at the root.
2. Run `omarchy plugin validate .` on an Omarchy machine.
3. Submit via [Publish a plugin](https://plugins.omarchy.org/publish.html) (GitHub issue form). Automated checks run on the current commit; a maintainer approves the listing.

`omarchy.*` ids are reserved; this plugin uses `2Dennis.zoom-in-out`.
