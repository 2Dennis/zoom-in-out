# Maintainer review

Plugin id: `io.github.2dennis.zoom-in-out`  
Repo: https://github.com/2Dennis/zoom-in-out  
Kind: headless `service` (no bar widget). MIT.

This is **text zoom** in the focused app (terminal font / browser page), like macOS Cmd++ / Cmd+-. It is **not** the screen magnifier (`Super+Ctrl+Z`).

## Install

```sh
omarchy plugin add https://github.com/2Dennis/zoom-in-out.git --enable
omarchy plugin validate ~/.config/omarchy/plugins/io.github.2dennis.zoom-in-out
```

On enable, the service:

1. Unbinds stock **window resize** on Super+minus / Super+equal
2. Binds those keys to zoom
3. Appends one `dofile(...)` line marked `io.github.2dennis.zoom-in-out` to `~/.config/hypr/bindings.lua`

## What to try

| Key | Expected |
| --- | --- |
| Focus **foot** (or another terminal), `Super` + `=` or `Super` + `+` | Font gets larger |
| Same window, `Super` + `-` | Font gets smaller |
| `Super` + `Ctrl` + `0` | Font reset |
| Focus a **browser**, same keys | Page zoom in / out / reset |
| `Super` + `0` | Still workspace 10 (not stolen) |
| `Super` + `Ctrl` + `Z` | Still cursor/screen magnifier |

Keyboard window resize should still work with **Super+Alt** or **Super+Ctrl** plus minus/equal.

## Remove

```sh
omarchy plugin remove io.github.2dennis.zoom-in-out
```

After remove: Super+minus / Super+equal should **resize the window** again, and the `dofile` line should be gone from `~/.config/hypr/bindings.lua`.

## Pass / fail

**Pass** if validate succeeds, Super++ / Super+- zoom the focused terminal and browser, Super+0 and Super+Ctrl+Z are unchanged, and remove restores resize.

**Fail** if Super++ still only resizes the window (binds never applied), or if remove leaves zoom binds / the `dofile` line behind.

## Do not treat as bugs

- Apps with no text-zoom shortcut, remotes, or custom keymaps
- Kitty / WezTerm if the user remapped font-size keys
- Wanting a screen magnifier (use `Super+Ctrl+Z`)
