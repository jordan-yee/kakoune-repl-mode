# An implementation of the repl-mode module for tmux.
# NOTE: Extended descriptions of each command can be found in the
# repl-mode-template.kak file.

provide-module repl-mode-tmux %{

    define-command -docstring "Open a REPL split below" \
    repl-mode-open-below %{
        evaluate-commands %sh{
            if [ "$kak_opt_repl_mode_new_repl_command" ]; then
                printf "%s\n" "tmux-repl-vertical $kak_opt_repl_mode_new_repl_command"
            else
                printf "%s\n" "tmux-repl-vertical"
            fi
        }
    }

    define-command -docstring "Open a REPL split to the right" \
    repl-mode-open-right %{
        evaluate-commands %sh{
            if [ "$kak_opt_repl_mode_new_repl_command" ]; then
                printf "%s\n" "tmux-repl-horizontal $kak_opt_repl_mode_new_repl_command"
            else
                printf "%s\n" "tmux-repl-horizontal"
            fi
        }
    }

    define-command -docstring "Open a REPL in a new tab" \
    repl-mode-open-tab %{
        evaluate-commands %sh{
            if [ "$kak_opt_repl_mode_new_repl_command" ]; then
                printf "%s\n" "tmux-repl-window $kak_opt_repl_mode_new_repl_command"
            else
                printf "%s\n" "tmux-repl-window"
            fi
        }
    }

    define-command -hidden \
    repl-mode-set-window-id %{
        set-option global tmux_repl_id %val{text}
    }

    # How to quickly get a specific ID in tmux:
    #  1) Focus the pane containing the REPL.
    #  2) Execute the tmux command:
    #  - `display-message -P '#{session_id}:#{window_id}.#{pane_id}'`
    #  - Adding an alias or binding for this is suggested.
    #  3) Press `D` or key bound to copy-end-of-line.
    #  4) Return to Kakoune and press `,ri` or trigger the `repl-mode-prompt-window-id` command.
    #  5) Press the tmux leader key followed by `]` or whichever key is bound to paste.
    #  - This will paste the line with the copied ID, including the newline, which will
    #    submit the prompt. The new REPL window ID is now set.
    #  6) Test the setting using the `repl-mode-focus` command below, or go ahead and use
    #     `repl-mode-send-text` or the default `repl-send-text`.
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
    repl-mode-prompt-window-id %{
        prompt 'Enter REPL window ID: ' repl-mode-set-window-id
    }

    define-command -docstring "Focus the REPL window" \
    repl-mode-focus %{
        nop %sh{
            tmux select-window -t $kak_opt_tmux_repl_id
            tmux select-pane -t $kak_opt_tmux_repl_id
        }
    }

    define-command -docstring "Send selected text to the REPL" \
    repl-mode-send-text %{
        repl-send-text
        repl-mode-focus
    }

    define-command -docstring "repl-mode-eval-text [text-to-eval]: Evaluate text at the REPL\n
    If no text is passed, then the selection is used" \
    repl-mode-eval-text -params ..1 %{
        evaluate-commands %sh{
            if [ $# -eq 0 ]; then
                printf "%s\n" "repl-send-text"
            else
                printf "%s %s\n" "repl-send-text %{$1}"
            fi
        }
        nop %sh{tmux send -t $kak_opt_tmux_repl_id "" C-m}
        repl-mode-focus
    }

    define-command -docstring "repl-mode-eval-last-command: Re-run the last executed command at the REPL" \
    repl-mode-eval-last-command %{
        nop %sh{tmux send -t $kak_opt_tmux_repl_id "Up" C-m}
        repl-mode-focus
    }

}
