--[[
nvim-colorizer.lua — Highlights color codes (e.g., #RRGGBB, rgb(), hsl(), etc.) directly in the editor.

Keybindings:
This plugin works automatically; no explicit keybindings are required.
Manual control commands:
  :ColorizerToggle         -> Toggle color highlighting on/off for the current buffer
  :ColorizerAttachToBuffer -> Attach colorizer manually to the current buffer
  :ColorizerDetachFromBuffer -> Detach colorizer from the current buffer
  :ColorizerReloadAllBuffers -> Reload colorizer for all buffers
]]

return {
    {
        -- Plugin: nvim-colorizer.lua — Display color codes inline with their actual color
        "norcalli/nvim-colorizer.lua",

        -- Load immediately (can be lazy-loaded if preferred)
        lazy = false,

        config = function()
            require("colorizer").setup({
                -- Enable color highlighting for all filetypes
                ["*"] = {
                    RGB = true,      -- #RGB hex codes
                    RRGGBB = true,   -- #RRGGBB hex codes
                    names = true,    -- Named colors like "Blue", "Red", etc.
                    RRGGBBAA = true, -- #RRGGBBAA hex codes with alpha
                    rgb_fn = true,   -- rgb() and rgba() functions
                    hsl_fn = true,   -- hsl() and hsla() functions
                    css = true,      -- Enable all CSS-related features
                    css_fn = true,   -- Enable all CSS functions
                },
            })
        end,
    },
}

