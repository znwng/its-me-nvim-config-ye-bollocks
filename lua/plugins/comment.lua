--[[
Keybinds / Behavior (Comment.nvim):

gcc        -> Toggle comment for the current line
gbc        -> Toggle block comment

gc<motion> -> Comment lines using motion (e.g., gcj to comment current + next line)
gb<motion> -> Block comment using motion

gcO        -> Add comment above the current line
gco        -> Add comment below the current line
gcA        -> Add comment at the end of the current line
]]

return {
    {
        -- Plugin: Comment.nvim — lightweight and fast commenting utility
        "numToStr/Comment.nvim",

        -- Load immediately on startup
        lazy = false,

        -- Plugin configuration using the opts table
        opts = {
            toggler = {
                line = "gcc",  -- Keymap to toggle a single line comment
                block = "gbc", -- Keymap to toggle a block comment
            },
            opleader = {
                line = "gc",  -- Motion-based line comment (e.g., gcj, gcap)
                block = "gb", -- Motion-based block comment
            },
            extra = {
                above = "gcO", -- Insert a comment line above the current line
                below = "gco", -- Insert a comment line below the current line
                eol = "gcA",   -- Insert a comment at the end of the current line
            },
        },
    },
}

