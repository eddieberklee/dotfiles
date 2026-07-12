# iTerm2 tmux window movement

This keymap makes `Ctrl` + `Shift` + `Command` + `H` move the current tmux
window left and `Ctrl` + `Shift` + `Command` + `L` move it right. The moved
window remains selected, including when it wraps around either end of the
window list.

The iTerm2 mapping sends two private escape sequences. [../rc/tmux.conf](../rc/tmux.conf)
registers them as `User0` and `User1` and uses `swap-window -d`; `-d` is what
keeps focus on the moved window instead of the window that takes its old index.

## Install

1. In iTerm2, open **Settings → Profiles**, then select every profile in which
   you run tmux.
2. Open **Keys → Key Mappings → Presets… → Import…** and choose
   [tmux-window-move.itermkeymap](tmux-window-move.itermkeymap).
3. Reload the tmux configuration currently used by the server:

   ```sh
   tmux source-file ~/.tmux.conf
   ```

The mappings are profile-specific. Repeat the import for another iTerm2
profile if that profile also runs tmux.

## Reference

| Shortcut | iTerm2 action | Bytes sent | tmux action |
| --- | --- | --- | --- |
| `Ctrl` + `Shift` + `Command` + `H` | Send Hex Codes | `ESC [ 5 ; 30012 ~` | Move the current window left |
| `Ctrl` + `Shift` + `Command` + `L` | Send Hex Codes | `ESC [ 5 ; 30013 ~` | Move the current window right |

The tmux bindings are global (`bind -n`), so they do not need the tmux prefix.
At either end of the window list, tmux wraps the window to the other end and
keeps it selected.

## Verify

Run this from any tmux pane:

```sh
tmux list-keys -T root | rg 'User[01].*swap-window'
```

It should include:

```text
bind-key -T root User0 swap-window -d -t :-1
bind-key -T root User1 swap-window -d -t :+1
```

Create at least two tmux windows, press either shortcut, and confirm that the
highlighted status-bar tab travels with the window being moved.

## Manual fallback

If you prefer not to import the file, add two entries in **Settings → Profiles
→ Keys → Key Mappings** yourself. For each entry, click the shortcut field and
press the chord, choose **Send Hex Codes**, then use the matching value below:

| Shortcut | Hex codes |
| --- | --- |
| `Ctrl` + `Shift` + `Command` + `H` | `0x1b 0x5b 0x35 0x3b 0x33 0x30 0x30 0x31 0x32 0x7e` |
| `Ctrl` + `Shift` + `Command` + `L` | `0x1b 0x5b 0x35 0x3b 0x33 0x30 0x30 0x31 0x33 0x7e` |

Check that iTerm2 displays `H` or `L` in the shortcut field. If it displays an
arrow instead, cancel that entry and record the intended letter chord again.
