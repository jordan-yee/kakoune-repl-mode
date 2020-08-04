# An implementation of the repl-mode module for tmux.
# NOTE: Extended descriptions of each command can be found in the
# repl-mode-template.kak file.

provide-module repl-mode-tmux %{

    define-command -docstring "Open a REPL split below" \
    repl-open-below %{
        tmux-repl-vertical
    }

    define-command -docstring "Open a REPL split to the right" \
    repl-open-right %{
        tmux-repl-horizontal
    }

    define-command -docstring "Open a REPL in a new tab" \
    repl-open-tab %{
        tmux-repl-window
    }

    define-command -hidden \
    repl-set-window-id %{
        set-option global tmux_repl_id %val{text}
    }

    # How to quickly get a specific ID in tmux:
    #  1) Focus the pane containing the REPL.
    #  2) Execute the tmux command:
    #  - `display-message -P '#{session_id}:#{window_id}.#{pane_id}'`
    #  - Adding an alias or binding for this is suggested.
    #  3) Press `D` or key bound to copy-end-of-line.
    #  4) Return to Kakoune and press `,ri` or trigger the `repl-prompt-window-id` command.
    #  5) Press the tmux leader key followed by `]` or whichever key is bound to paste.
    #  - This will paste the line with the copied ID, including the newline, which will
    #    submit the prompt. The new REPL window ID is now set.
    #  6) Test the setting using the `repl-focus` command below, or go ahead and use
    #     `repl-send-text` or the default `send-text`.
    # My Keypresses (example):
    # - My tmux leader key is <c-w>.
    # - My Kakoune user-mode key is <space>.
    # - My repl-mode binding is <r>.
    #  1) <c-w>n
    #  2) <c-w>:did<ret>
    #  3) D
    #  4a) <c-w>p
    #  4b) <space>ri
    #  5) <c-w>]
    define-command -docstring "Set REPL window ID" \
    repl-prompt-window-id %{
        prompt 'Enter REPL window ID: ' repl-set-window-id
    }

    define-command -docstring "Focus the REPL window" \
    repl-focus %{
        # TODO: Not sure how to handle this when the shell block isn't returning
        #       something to be evaluated by Kakoune. Prefixing the sh block
        #       with with either evaluate-commands or echo prevents a command
        #       not found error.
        echo %sh{
            tmux select-window -t $kak_opt_tmux_repl_id
            tmux select-pane -t $kak_opt_tmux_repl_id
        }
    }

    define-command -docstring "Send selected text to the REPL" \
    repl-send-text %{
        send-text
        repl-focus
    }

}
