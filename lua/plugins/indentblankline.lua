return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            enabled = false,
            indent = { char = "│" },
            scope = { enabled = false },
        },
        keys = {
            {
                "<leader>il",
                "<cmd>IBLToggle<cr>",
                desc = "Toggle indent guides",
            },
        },
    },
}

