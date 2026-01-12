--[[
nvim-colorizer.lua
Shows color codes (like #RRGGBB, rgb(), hsl(), etc.) in their actual color inside the editor.

Commands you can use (optional, since it works automatically):
  :ColorizerToggle            -> Turn color highlighting on/off in current file
  :ColorizerAttachToBuffer    -> Start color highlighting manually
  :ColorizerDetachFromBuffer  -> Stop color highlighting in current file
  :ColorizerReloadAllBuffers  -> Reload color highlighting in all files
]]

return {
    {
        -- Highlight colors directly in the code (hex, rgb(), hsl(), names, etc.)
        "norcalli/nvim-colorizer.lua",

        -- Load right away (not lazy-loaded)
        lazy = false,

        config = function()
            require("colorizer").setup({
                -- Apply to all filetypes
                ["*"] = {
                    RGB = true, -- Short hex colors (#RGB)
                    RRGGBB = true, -- Full hex colors (#RRGGBB)
                    names = true, -- Named colors (e.g. "Blue", "Red")
                    RRGGBBAA = true, -- Hex with alpha channel (#RRGGBBAA)
                    rgb_fn = true, -- rgb() and rgba() functions
                    hsl_fn = true, -- hsl() and hsla() functions
                    css = true, -- Enable CSS color features
                    css_fn = true, -- Enable CSS functions
                },
            })
        end,
    },
}

