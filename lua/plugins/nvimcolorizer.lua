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
                options = {
                    parsers = {
                        rgb = true,
                        rrggbb = true,
                        rrggbbaa = true,
                        names = true,
                        hsl = true,
                        css = true,
                    },
                    display = {
                        mode = "background",
                    },
                },
            })
        end,
    },
}

