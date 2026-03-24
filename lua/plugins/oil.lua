return {
    {
        "stevearc/oil.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            view_options = {
                show_hidden = true,
            },
        },
        keys = {
            {
                "<leader>o",
                "<cmd>Oil<CR>",
                desc = "Open file explorer",
            },
        },
    },
}

