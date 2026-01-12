--[[
Keybindings for vim-visual-multi:

<C-n>     → Select next occurrence (press repeatedly to select more)
<C-p>     → Select previous occurrence
<C-x>     → Skip occurrence
<C-down>  → Add a cursor downward
<C-up>    → Add a cursor upward
Shift + I → Enter Insert mode at all cursors
Shift + A → Enter Append mode at all cursors
Esc       → Exit multi-cursor mode
]]

return {
    {
        -- Plugin: vim-visual-multi — Multi-cursor editing for Neovim
        "mg979/vim-visual-multi",

        -- Use the stable branch
        branch = "master",

        -- No additional config required: works out-of-the-box
        -- Customization is possible via g:VM_* variables (see :help vm-config)
    },
}

