return {
    "folke/todo-comments.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    event = "BufReadPost",

    opts = {
        signs = false,
        highlight = {
            keyword = "bg",
        },

        keywords = {
            TODO = { color = "info" },
            FIXME = { color = "error" },
            NOTE = { color = "hint" },
            HACK = { color = "warning" },
            PERF = { color = "warning" },
            BUG = { color = "error" },
            REVIEW = { color = "info" },
        },
    },

    keys = {
        {
            "<leader>ft",
            "<cmd>TodoTelescope<CR>",
            desc = "Find TODOs",
        },
    },
}
