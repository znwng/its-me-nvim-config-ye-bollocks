return {
    {
        "ellisonleao/glow.nvim",
        cmd = "Glow",
        config = function()
            require("glow").setup({
                style = "dark",
                width_ratio = 0.8,
                height_ratio = 0.8,
                border = "rounded",
            })
        end,
    },
}

