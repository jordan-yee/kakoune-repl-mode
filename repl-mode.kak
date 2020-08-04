# Plugin Name: repl-mode
# Description: Commands and mappings to streamline REPL interaction.
# Author: Jordan Yee

# Suggested user mode mapping
# map global user r ': enter-user-mode repl<ret>' -docstring "repl mode"

# Since different window managers have different terminology, the following terms
# are being used for this interface:
# > tab    -- tmux window / vim tab page
# > window -- tmux pane / vim window
# > below  -- tmux vertical split / vim horizontal split
# > right  -- tmux horizontal split / vim vertical split

declare-option -docstring 'window manager implementation to use
Currently supported implementations:
    tmux (default)' \
str repl_mode_window_manager 'tmux'

hook global ModuleLoaded repl-mode %{
    declare-user-mode repl
    map global repl l ': repl-open-right<ret>' -docstring "Open a REPL split to the right"
    map global repl j ': repl-open-below<ret>' -docstring "Open a REPL split below"
    map global repl t ': repl-open-tab<ret>' -docstring "Open a REPL in a new tab"
    map global repl i ': repl-prompt-window-id<ret>' -docstring "Set REPL window ID"
    map global repl o ': repl-focus<ret>' -docstring "Focus the REPL window"
    map global repl s ': repl-send-text<ret>' -docstring "Send selected text to REPL"
}

# NOTE: File containing provide-module for the window manager specified by the
#       `repl_window_manager` option must be sourced before the repl-mode
#       module is required.
provide-module repl-mode %{
    evaluate-commands %sh{
        printf "%s\n" "require-module repl-mode-$kak_opt_repl_mode_window_manager"
    }
}
