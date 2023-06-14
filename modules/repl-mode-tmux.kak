# An implementation of the repl-mode module for tmux.
# NOTE: Extended descriptions of each command can be found in the
# repl-mode-template.kak file.

provide-module -override repl-mode-tmux %{

    define-command -override -docstring "Open a REPL split below" \
    repl-mode-open-below %{
        evaluate-commands %sh{
            if [ "$kak_opt_repl_mode_new_repl_command" ]; then
                printf "%s\n" "tmux-repl-vertical $kak_opt_repl_mode_new_repl_command"
            else
                printf "%s\n" "tmux-repl-vertical"
            fi
        }
    }

    define-command -override -docstring "Open a REPL split to the right" \
    repl-mode-open-right %{
        evaluate-commands %sh{
            if [ "$kak_opt_repl_mode_new_repl_command" ]; then
                printf "%s\n" "tmux-repl-horizontal $kak_opt_repl_mode_new_repl_command"
            else
                printf "%s\n" "tmux-repl-horizontal"
            fi
        }
    }

    define-command -override -docstring "Open a REPL in a new tab" \
    repl-mode-open-tab %{
        evaluate-commands %sh{
            if [ "$kak_opt_repl_mode_new_repl_command" ]; then
                printf "%s\n" "tmux-repl-window $kak_opt_repl_mode_new_repl_command"
            else
                printf "%s\n" "tmux-repl-window"
            fi
        }
    }

    define-command -override -hidden \
    repl-mode-set-window-id %{
        set-option global tmux_repl_id %val{text}
    }

    define-command -override -docstring "Set REPL window ID" \
    repl-mode-prompt-window-id %{
        prompt 'Enter REPL window ID: ' repl-mode-set-window-id
    }

    define-command -override -hidden -docstring "Fail if REPL window ID isn't set" \
    repl-mode-require-connected-repl %{
        evaluate-commands %sh{
            if [ -z "$kak_opt_tmux_repl_id" ]; then
                echo 'fail A REPL window ID is not set!'
            else
                echo 'nop'
            fi
        }
    }

    define-command -override -docstring "Focus the REPL window" \
    repl-mode-focus %{
        repl-mode-require-connected-repl
        nop %sh{
            tmux select-window -t $kak_opt_tmux_repl_id
            tmux select-pane -t $kak_opt_tmux_repl_id
        }
    }

    define-command -override -docstring "Send selected text to the REPL" \
    repl-mode-send-text %{
        repl-mode-require-connected-repl
        repl-send-text
        repl-mode-focus
    }

    define-command -override -docstring "repl-mode-eval-text [text-to-eval]: Evaluate text at the REPL\n
    If no text is passed, then the selection is used" \
    repl-mode-eval-text -params ..1 %{
        repl-mode-require-connected-repl
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

    define-command -override -docstring "repl-mode-eval-last-command: Re-run the last executed command at the REPL" \
    repl-mode-eval-last-command %{
        repl-mode-require-connected-repl
        nop %sh{tmux send -t $kak_opt_tmux_repl_id "Up" C-m}
        repl-mode-focus
    }

}
