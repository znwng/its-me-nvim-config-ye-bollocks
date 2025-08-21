--[[
nvim-colorizer.lua — Highlights color codes (e.g., #RRGGBB, rgb(), hsl(), etc.) directly in the editor.

Keybindings:
This plugin does not require explicit keybindings — it works automatically when you open a file.
However, you can control it manually with the following commands:
  :ColorizerToggle       -> Toggle color highlighting on/off for the current buffer
  :ColorizerAttachToBuffer -> Attach colorizer manually to the current buffer
  :ColorizerDetachFromBuffer -> Detach colorizer from the current buffer
  :ColorizerReloadAllBuffers -> Reload colorizer for all buffers
]]

return {
    {
        -- Plugin: nvim-colorizer.lua — Display colors inline
        "norcalli/nvim-colorizer.lua",

        -- Load immediately (you can make this lazy if preferred)
        lazy = false,

        config = function()
            require("colorizer").setup({
                -- Enable color highlighting for common filetypes
                -- (You can add/remove filetypes as needed)
                ["*"] = {            -- Enable for all filetypes
                    RGB = true,      -- #RGB hex codes
                    RRGGBB = true,   -- #RRGGBB hex codes
                    names = true,    -- "Blue", "Red", etc.
                    RRGGBBAA = true, -- #RRGGBBAA hex codes
                    rgb_fn = true,   -- rgb() and rgba()
                    hsl_fn = true,   -- hsl() and hsla()
                    css = true,      -- Enable all CSS features
                    css_fn = true,   -- Enable all CSS *functions*
                },
            })
        end,
    },
}

