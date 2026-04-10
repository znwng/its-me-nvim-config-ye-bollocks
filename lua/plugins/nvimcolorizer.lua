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

