return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                direction = "horizontal",
                size = 10,
            })
        end,

        vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>"),
    },
}

