--[[
Comment.nvim (comment lines or blocks quickly)

Keymaps:
gcc        -> Toggle comment on current line
gbc        -> Toggle block comment

gc<motion> -> Comment by motion (e.g. gcj = this + next line)
gb<motion> -> Block comment by motion

gcO        -> Add comment line above
gco        -> Add comment line below
gcA        -> Add comment at end of line
]]

return {
    {
        -- Comment plugin (lightweight, fast)
        "numToStr/Comment.nvim",

        -- Load right away
        lazy = false,

        -- Setup keymaps
        opts = {
            toggler = {
                line = "gcc", -- Toggle single line
                block = "gbc", -- Toggle block
            },
            opleader = {
                line = "gc", -- Use motions with gc (e.g. gcj, gcap)
                block = "gb", -- Use motions with gb
            },
            extra = {
                above = "gcO", -- Add comment above
                below = "gco", -- Add comment below
                eol = "gcA", -- Add comment at end of line
            },
        },
    },
}

