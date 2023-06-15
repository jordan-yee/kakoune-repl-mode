# kakoune-repl-mode
A [Kakoune](http://kakoune.org) plugin providing improved REPL interaction.

This plugin intends to provide a window-manager-agnostic set of commands and
mappings for interacting with a REPL that improve upon and extend the REPL
commands that ship with Kakoune.

Currently, only TMUX functionality is included, but a generic interface is
provided to make it as easy as possible to add support for a different window
manager (see the `repl-mode-template.kak` file).

# Usage
The suggested user mode binding for activating repl mode is:
```
map global user r ': enter-user-mode repl<ret>' -docstring "repl mode"
```
The assigned mappings for repl mode were chosen to be mechanically fluid when
used with this suggested leader key.

> While this plugin was written with the idea of evaluating source code at a
> REPL, another really nice use case I've found is to evaluate shell commands,
> such as those included in A README file.
>
> While viewing a README, you can quickly open a connected repl-terminal split
> from Kakoune with `<space>rl`, select the command, then eval it with
> `<space>re`.

## Provided 'repl' mode mappings

| key | command                     | description                        |
| --- | --------------------------  | ---------------------------------- |
| l   | repl-mode-open-right        | Open a REPL split to the right     |
| j   | repl-mode-open-below        | Open a REPL split below            |
| w   | repl-mode-open-tab          | Open a REPL in a new tab (window)  |
| i   | repl-mode-prompt-window-id  | Set REPL window ID                 |
| I   | repl-mode-select-window-id  | Select REPL window ID from a menu  |
| o   | repl-mode-focus             | Focus the REPL window              |
| s   | repl-mode-send-text         | Send selected text to REPL         |
| e   | repl-mode-eval-text         | Evaluate selected text at the REPL |
| .   | repl-mode-eval-last-command | Evaluate last command at the REPL  |

## Other Commands

`repl-mode-set-new-repl-command <value>`: Set the command used to open a new
REPL in the current and window scope.
- This is unset by default, meaning the open repl commands will simply open a
  terminal that you can send-text to.
- You can set this to start an actual REPL for the current window's filetype
  (see example in installation instructions below).

## Differences to stock repl commands
- The built-in `repl` command is equivalent to the `repl-mode-open-right`
  command when using tmux.
- The `repl-mode-send-text` command improves upon the built-in `send-text`
  command by focusing the REPL window after sending text, while still allowing
  modifications to be made before executing.
- The `repl-mode-prompt-window-id` command is including to address the problem
  of losing the "connection" to the REPL window when moving it. This may not be
  a problem for all window managers, but it is a problem when moving the REPL
  window (tmux pane) to a new tab (tmux window) in tmux.
  - A recipe for quickly fixing the reference for tmux is provided below.
- The functionality provided by the other commands is unique to this plugin.

## Connection to a REPL pane when using TMUX

### The new way

To set the target REPL window when using TMUX, you can now use the
`repl-mode-select-window-id` command (mapped to repl mode I by default, so
`<space>rI`).

This will open the `tmux choose-tree` menu, filtered by windows with "repl" in
their name. Press enter on a pane to set that as the new target REPL window.

If your target window does not include "repl" in its name, you can clear the
filter by pressing `f<c-u><ret>`.

### The old (but still valid) way

When opening a REPL using the included commands/mappings, the REPL ID is
automatically registered. If you restart Kakoune or otherwise want to connect
to an existing REPL pane, you would use the `repl-mode-prompt-window-id`
command (mapped to `i` by default). The problem then becomes how to get the
target window id. Below is the strategy I use for getting the ID in TMUX.

How to quickly get a specific ID in tmux (manual steps):
1. Focus the pane containing the REPL.
2. Execute the tmux command:
   - `display-message -P '#{session_id}:#{window_id}.#{pane_id}'`
3. Press `D` or key bound to copy-end-of-line.
4. Return to Kakoune and press `,ri` or trigger the `repl-mode-prompt-window-id`
   command.
5. Press the tmux leader key followed by `]` or whichever key is bound to paste.
   - This will paste the line with the copied ID, including the newline, which
     will submit the prompt. The new REPL window ID is now set.
6. Test the setting using the `repl-mode-focus` command below, or go ahead and
   use `repl-mode-send-text` or the default `repl-send-text`.

To automate those manual steps a bit, add the following to your `.tmux.conf`:
```
# Copy ID
set-option -s command-alias[0] cpid="display-message -p '#{session_id}:#{window_id}.#{pane_id}'; send 'D'"
bind I "cpid"
```

My Keypresses (example):
- My tmux leader key is `<c-w>`.
- My Kakoune user-mode key is `<space>`.
- My repl-mode binding is `<r>`.
- Assuming target REPL is the "next" window.

1. Focus target REPL pane: `<c-w>n`
2. Execute TMUX binding to copy the pane ID: `<c-w>I`
4. Return to Kakoune: `<c-w>p`
5. Trigger mapping for "repl-mode-prompt-window-id" command: `<space>ri`
6. TMUX paste (which includes a newline that submits the prompt): `<c-w>]`
7. Focus the REPL via the Kakoune mapping: `<space>ro`

# Installation
This plugin requires the windowing scripts that ship with Kakoune when using
the included tmux repl-mode implementation.

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
      complete-command -menu repl-mode-set-new-repl-command shell-script-candidates %{
          printf '%s\n' 'clojure -M:repl/reloaded' 'lein repl :connect' 'lein repl'
      }

      hook -once -always window WinSetOption filetype=.* %{
        unset-option window repl_mode_new_repl_command
      }
    }
}
```

## Installing manually
Download `repl-mode.kak` and whichever window manager script(s) you wish to
use, and either source them in your kakrc or copy them to your autoload folder,
then add the following to your kakrc:
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

# Terminology
Since different window managers have different terminology, the following terms
are being used for this plugin:

| term   | meaning                                    |
| ------ | ------------------------------------------ |
| tab    | tmux window / vim tab page                 |
| window | tmux pane / vim window                     |
| below  | tmux vertical split / vim horizontal split |
| right  | tmux horizontal split / vim vertical split |

# Development
The kakscript in this plugin is [*mostly] written to be reloadable so that you
can source it after making a change to test things without restarting Kakoune.
I use this [quick-dev plugin](https://github.com/jordan-yee/kakoune-plugin-quick-dev)
to do that:
1. Disable the installation+configuration in kakrc & restart kak.
2. Open kakoune, then open the quick-dev file with `<space>qe`.
3. Source file(s) you're working on:
   ```
   # Command to copy filepath for current buffer:
   # `:eval reg dquote %val{buffile}`
   source "<path-to>/repl-mode.kak"
   source "<path-to>/repl-mode-tmux.kak"
   ```
4. If needed, copy your config below the sourced files and make sure it's
   adjusted to be reloadable. (Such as if you want to change mappings.)
5. Edit the plugin scripts, probably by selecting the sourced path and pressing
   `gf`.
   - If you're editing a module, you'll have to temporarily disable the module
     to enable reloading.
6. After making changes press `<space>qr` to reload them.
7. Test your changes and repeat.

*except for the use of modules, which are not reloadable

**TODO**
- [ ] Update things so that you can essentially copy/paste the installation
  blurb into the quick-dev scratch pad and go, or otherwise reload everything
  at once.

# Design Notes
This plugin was written with [these principles](https://github.com/jordan-yee/principles/blob/master/kakoune-plugins.md) in mind.
