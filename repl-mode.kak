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

declare-option -docstring 'the command used to launch a REPL' \
str repl_mode_new_repl_command

define-command repl-mode-set-new-repl-command -params 1 \
-docstring 'repl-mode-set-new-repl-command <value>: set the command used to open a new REPL in the current window scope' \
%{
    set-option window repl_mode_new_repl_command %arg{1}
}

define-command repl-mode-register-default-mappings %{
    declare-user-mode repl
    map global repl l ': repl-mode-open-right<ret>' -docstring "Open a REPL split to the right"
    map global repl j ': repl-mode-open-below<ret>' -docstring "Open a REPL split below"
    map global repl w ': repl-mode-open-tab<ret>' -docstring "Open a REPL in a new tab (window)"
    map global repl i ': repl-mode-prompt-window-id<ret>' -docstring "Set REPL window ID"
    map global repl o ': repl-mode-focus<ret>' -docstring "Focus the REPL window"
    map global repl s ': repl-mode-send-text<ret>' -docstring "Send selected text to REPL"
    map global repl e ': repl-mode-eval-text<ret>' -docstring "Evaluate selected text at the REPL"
}

# NOTE: File containing provide-module for the window manager specified by the
#       `repl_window_manager` option must be sourced before the repl-mode
#       module is required.
provide-module repl-mode %{
    evaluate-commands %sh{
        printf "%s\n" "require-module repl-mode-$kak_opt_repl_mode_window_manager"
    }
}
