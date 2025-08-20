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
        -- Plugin: Comment.nvim — simple, fast commenting
        "numToStr/Comment.nvim",

        -- Load immediately (not lazy)
        lazy = false,

        -- Use opts table instead of manual setup()
        opts = {
            toggler = {
                line = "gcc",  -- Toggle line comment
                block = "gbc", -- Toggle block comment
            },
            opleader = {
                line = "gc",  -- Motion-based line comment (e.g., gcj, gcap)
                block = "gb", -- Motion-based block comment
            },
            extra = {
                above = "gcO", -- Add comment line above
                below = "gco", -- Add comment line below
                eol = "gcA",   -- Add comment at end of line
            },
        },
    },
}

