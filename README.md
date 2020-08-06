# kakoune-repl-mode
Kakoune plugin providing improved REPL interaction

This plugin intends to provide a window-manager-agnostic set of commands and
mappings for interacting with a REPL that improve upon and extend the REPL
commands that ship with Kakoune.

Currently, only tmux functionality is included, but the plugin is setup to
make it as easy as possible to add support for a different window manager. See
the `repl-mode-template.kak` file for more more information.

# Installation

## Installing with plug.kak
Add the following to your kakrc:
```
plug "jordan-yee/kakoune-repl-mode" config %{
    # Suggested user mode mapping
    map global user r ': enter-user-mode repl<ret>' -docstring "repl mode"

    # Optionally set the window manager if not using tmux
    #  (The following will only work if you've provided a custom
    #  repl-mode-kitty module. Copy repl-mode-template.kak to get started.)
    set-option global repl_mode_window_manager 'kitty'
    
    require-module repl-mode
}
```

## Installing manually
Download the repl-mode.kak script and whichever window-manager script(s) you
wish to use, and either source them in your kakrc or copy them to your
autoload folder, then add the following to your kakrc:
```
# Optionally set the window manager
# This option will be set to 'tmux' by default
set-option global repl_window_manager 'tmux'

hook global ModuleLoaded repl-mode %{
    # Suggested binding
    map global user r ': enter-user-mode repl<ret>' -docstring "repl mode"
}

require-module repl-mode
```

# Usage

The suggested user mode binding for activating repl mode is:
```
map global user r ': enter-user-mode repl<ret>' -docstring "repl mode"
```
The assigned mappings for repl mode were chosen to be mechanically fluid when
used with this suggested leader key.

| key | command               | description                    |
| --- | --------------------- | ------------------------------ |
| l   | repl-open-right       | Open a REPL split to the right |
| j   | repl-open-below       | Open a REPL split below        |
| t   | repl-open-tab         | Open a REPL in a new tab       |
| i   | repl-prompt-window-id | Set REPL window ID             |
| o   | repl-focus            | Focus the REPL window          |
| s   | repl-send-text        | Send selected text to REPL     |

## Functionality Notes

- The built-in `repl` command is equivalent to the `repl-open-right` command
  when using tmux.
- The `repl-send-text` command improves upon the `send-text` command by
  focusing the REPL window after sending text. This allows you to immediately
  execute the command by pressing enter, while still allowing modifications
  to be made before executing.
- The `repl-prompt-window-id` command is including to address the problem of
  losing the "connection" to the REPL window when moving it. This may not be
  a problem for all window managers, but it is a problem when moving the REPL
  window (tmux pane) to a new tab (tmux window) in tmux.
  - A recipe for quickly fixing the reference for tmux is provided in the
    `repl-mode-tmux.kak` script.

# Terminology

Since different window managers have different terminology, the following terms
are being used for this plugin:

| term   | meaning                                    |
| ------ | ------------------------------------------ |
| tab    | tmux window / vim tab page                 |
| window | tmux pane / vim window                     |
| below  | tmux vertical split / vim horizontal split |
| right  | tmux horizontal split / vim vertical split |
