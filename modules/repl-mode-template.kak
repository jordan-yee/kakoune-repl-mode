# TODO: Implement each of the commands in the repl-mode module for the target
#       window manager. When finished delete all TODO comment blocks.

# An implementation of the repl-mode module for {window-manager}.
# NOTE: Extended descriptions of each command can be found in the
# repl-mode-template.kak file.

# TODO:
# COMMANDS:
# [ ] repl-mode-open-below
# [ ] repl-mode-open-right
# [ ] repl-mode-open-tab
# [ ] repl-mode-set-window-id -hidden
# [ ] repl-mode-prompt-window-id
# [ ] repl-mode-focus
# [ ] repl-mode-send-text
# [ ] repl-mode-eval-text
# [ ] repl-mode-eval-last-command

# The below actions can be performed using a window manager, but are not
# currently included in this module. Adding them would enable the REPL window
# ID option to be updated after the REPL window is moved, which may not be an
# issue for all window managers to begin with. They'd also be a convenience to
# put the REPL right where you want it on a whim:
# BAM! The REPL appears beneath the current window to quickly execute a command.
# BAM! The REPL is sent to another tab, out of sight.
# [ ] repl-mode-move-below
# [ ] repl-mode-move-right
# [ ] repl-mode-move-tab

# TODO: Rename 'template' to the name of the window manager you're implementing
# functionality for. Whatever you replace `template` with is what you'll need
# to set the `repl_mode_window_id` option to for this implementation.
provide-module -override repl-mode-template %{

    # TODO: Open a split window below the current window and set an option that
    # indicates the ID of the newly created REPL window. This option can then
    # be used by the other commands to reference the REPL window.
    define-command -override -docstring "Open a REPL split below" \
    repl-mode-open-below %{
        fail "Command not implemented: repl-mode-open-below"
    }

    # TODO: Open a split window to the right of the current window and set an
    # option that indicates the ID of the newly created REPL window. This
    # option can then be used by the other commands to reference the REPL
    # window.
    define-command -override -docstring "Open a REPL split to the right" \
    repl-mode-open-right %{
        # Existing alias for several window managers:
        # repl
        fail "Command not implemented: repl-mode-open-right"
    }

    # TODO: Open a window in a new tab and set an option that indicates the ID
    # of the newly created REPL window. This option can then be used by the
    # other commands to reference the REPL window.
    define-command -override -docstring "Open a REPL in a new tab" \
    repl-mode-open-tab %{
        fail "Command not implemented: repl-mode-open-tab"
    }

    # TODO: Hidden command used to set the ID of the window containing the
    # REPL. The window ID is meant to be the coordinates for the REPL window
    # that enable it to be selected by the window manager regardless of which
    # tab or window is focused.
    define-command -override -hidden \
    repl-mode-set-window-id %{
        # Suggested implementation:
        #set-option global {window-manager}_repl_id %val{text}
        fail "Command not implemented: repl-mode-set-window-id"
    }

    # TODO: Prompt the user to enter the ID of the window containing a REPL,
    # and set an option to be used by other commands to reference the REPL
    # window. The default implementation is probably fine, just implement the
    # `repl-mode-set-window-id` command above.
    define-command -override -docstring "Set REPL window ID" \
    repl-mode-prompt-window-id %{
        prompt 'Enter REPL window ID: ' repl-mode-set-window-id
    }

    # TODO: Focus the window containing a REPL, as indicated by the repl id
    # option set either automatically by a `repl-mode-open-*` command or
    # manually via the `repl-mode-prompt-window-id` command.
    define-command -override -docstring "Focus the REPL window" \
    repl-mode-focus %{
        fail "Command not implemented: repl-mode-focus"
    }

    # TODO: Send text to the REPL window and focus it. Ideally, this should
    # also check whether the currently set REPL window id is a Kakoune client
    # and abort with an error message to prevent unintended keys from executing
    # in an instance of Kakoune.
    define-command -override -docstring "Send selected text to the REPL" \
    repl-mode-send-text %{
        # Existing alias for several window managers:
        # send-text

        # Focus the REPL window after send-text to edit and/or evaluate it.
        # repl-mode-focus
        fail "Command not implemented: repl-mode-send-text"
    }

    # TODO: Send text to the REPL window to be evaluated and focus it. Ideally,
    # this should also check whether the currently set REPL window id is a
    # Kakoune client and abort with an error message to prevent unintended keys
    # from executing in an instance of Kakoune.
    define-command -override -docstring "repl-mode-eval-text [text-to-eval]: Evaluate selected text OR [text-to-eval], if given, at the REPL" \
    repl-mode-eval-text -params ..1 %{
        # Existing alias for several window managers:
        # send-text

        # Focus the REPL window after sending text to be evaluated.
        # repl-mode-focus
        fail "Command not implemented: repl-mode-eval-text"
    }

    # TODO: Send an up-arrow keypress to the REPL window and focus it. Ideally,
    # this should also check whether the currently set REPL window id is a
    # Kakoune client and abort with an error message to prevent unintended keys
    # from executing in an instance of Kakoune.
    define-command -override -docstring "repl-mode-eval-last-command: Re-run the last executed command at the REPL" \
    repl-mode-eval-last-command %{
        # Existing alias for several window managers:
        # repl-send-text

        # Focus the REPL window after sending text to be evaluated.
        # repl-mode-focus
        fail "Command not implemented: repl-mode-eval-last-command"
    }

}
