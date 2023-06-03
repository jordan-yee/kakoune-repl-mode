# kakoune-repl-mode
[Kakoune](http://kakoune.org) plugin providing improved REPL interaction

This plugin intends to provide a window-manager-agnostic set of commands and
mappings for interacting with a REPL that improve upon and extend the REPL
commands that ship with Kakoune.

Currently, only tmux functionality is included, but the plugin is set up to
make it as easy as possible to add support for a different window manager. See
the `repl-mode-template.kak` file for more more information.

# Usage
The suggested user mode binding for activating repl mode is:
```
map global user r ': enter-user-mode repl<ret>' -docstring "repl mode"
```
The assigned mappings for repl mode were chosen to be mechanically fluid when
used with this suggested leader key.

## repl mode mappings

| key | command                     | description                        |
| --- | --------------------------  | ---------------------------------- |
| l   | repl-mode-open-right        | Open a REPL split to the right     |
| j   | repl-mode-open-below        | Open a REPL split below            |
| w   | repl-mode-open-tab          | Open a REPL in a new tab (window)  |
| i   | repl-mode-prompt-window-id  | Set REPL window ID                 |
| o   | repl-mode-focus             | Focus the REPL window              |
| s   | repl-mode-send-text         | Send selected text to REPL         |
| e   | repl-mode-eval-text         | Evaluate selected text at the REPL |
| .   | repl-mode-eval-last-command | Evaluate last command at the REPL  |

## Other Commands

`repl-mode-set-new-repl-command <value>`: set the command used to open a new REPL in the current window scope

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

## Connection to a REPL pane when using TMUX
When opening a REPL using the included commands/mappings, the REPL ID is
automatically registered. If you restart Kakoune or otherwise want to connect to
an existing REPL pane, you would use the `repl-mode-prompt-window-id` command
(mapped to `i` by default). The problem then becomes how to get the target
window id. Below is the strategy I use for getting the ID in TMUX.

How to quickly get a specific ID in tmux:
1. Focus the pane containing the REPL.
2. Execute the tmux command:
   - `display-message -P '#{session_id}:#{window_id}.#{pane_id}'`
   - Adding an alias or binding for this is suggested.
3. Press `D` or key bound to copy-end-of-line.
4. Return to Kakoune and press `,ri` or trigger the `repl-mode-prompt-window-id` command.
5. Press the tmux leader key followed by `]` or whichever key is bound to paste.
   - This will paste the line with the copied ID, including the newline, which will
     submit the prompt. The new REPL window ID is now set.
6. Test the setting using the `repl-mode-focus` command below, or go ahead and use
   `repl-mode-send-text` or the default `repl-send-text`.

My Keypresses (example):
- My tmux leader key is `<c-w>`.
- My Kakoune user-mode key is `<space>`.
- My repl-mode binding is `<r>`.
- Assuming target REPL is the "next" window.

1. Focus target REPL pane: `<c-w>n`
2. Execute aliased TMUX command to display ID: `<c-w>:did<ret>`
3. Copy the displayed ID to the TMUX clipboard: `D`
4. Return to Kakoune: `<c-w>p`
5. Trigger mapping for "repl-mode-prompt-window-id" command: `<space>ri`
6. TMUX paste (which includes a newline that submits the prompt): `<c-w>]`
7. Focus the REPL via the Kakoune mapping: `<space>ro`

# Terminology
Since different window managers have different terminology, the following terms
are being used for this plugin:

| term   | meaning                                    |
| ------ | ------------------------------------------ |
| tab    | tmux window / vim tab page                 |
| window | tmux pane / vim window                     |
| below  | tmux vertical split / vim horizontal split |
| right  | tmux horizontal split / vim vertical split |

# Installation
This plugin requires the windowing scripts that ship with Kakoune when using the
included tmux repl-mode implementation.

## Installing with plug.kak
To install with [plug.kak](https://github.com/andreyorst/plug.kak), add the
following to your kakrc, then run the `:plug-install` command:
```
plug "jordan-yee/kakoune-repl-mode" config %{
    require-module repl-mode

    # Suggested user mode mapping:
    map global user r ': enter-user-mode repl<ret>' -docstring "repl mode"

    # Register default mappings for the `repl` user-mode:
    repl-mode-register-default-mappings

    # Optionally set the window manager if not using tmux
    #  (The following will only work if you've provided a custom
    #  repl-mode-kitty module. Copy repl-mode-template.kak to get started.)
    set-option global repl_mode_window_manager 'kitty'

    # Optionally set a command to launch a new REPL
    # - This is unset by default, which will cause new REPL windows to simply
    #   open a shell prompt.
    # - The provided repl-mode-tmux implementation uses this option, but you
    #   will have to handle it yourself if implementing the commands for a
    #   different terminal/window manager.
    # - You will likely want to set this differently for different languages,
    #   or even different projects.
    hook global WinSetOption filetype=clojure %{
      set-option window repl_mode_new_repl_command 'lein repl'

      hook -once -always window WinSetOption filetype=.* %{
        unset-option window repl_mode_new_repl_command
      }
    }
}
```

## Installing manually
Download `repl-mode.kak` and whichever window manager script(s) you
wish to use, and either source them in your kakrc or copy them to your
autoload folder, then add the following to your kakrc:
```
# Optionally set the window manager
# This option will be set to 'tmux' by default
set-option global repl_window_manager 'tmux'

# Ensure the repl-mode commands are loaded:
require-module repl-mode

# Suggested user mode mapping
map global user r ': enter-user-mode repl<ret>' -docstring "repl mode"

# Register default mappings for the `repl` user-mode:
repl-mode-register-default-mappings
```

# Design Notes
This plugin was written with [these principles](https://github.com/jordan-yee/principles/blob/master/kakoune-plugins.md) in mind.
