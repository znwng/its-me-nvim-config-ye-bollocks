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
        "NvChad/nvim-colorizer.lua",
        lazy = false,
        config = function()
            require("colorizer").setup({
                filetypes = { "*" },
                user_default_options = {
                    RGB = true,
                    RRGGBB = true,
                    names = true,
                    RRGGBBAA = true,
                    rgb_fn = true,
                    hsl_fn = true,
                    css = true,
                    css_fn = true,
                },
            })
        end,
    },
}

