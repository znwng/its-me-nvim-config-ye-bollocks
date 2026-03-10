return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",

        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            lazy = false,
        },

        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                indent = { enable = true },
            })
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "python",
                    "c",
                    "cpp",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "go",
                    "rust",
                    "java",
                    "typst",
                },

                sync_install = true,

                highlight = { enable = true },
                indent = { enable = true },

                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },

                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]c"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[c"] = "@class.outer",
                        },
                    },
                },
            })

            local group = vim.api.nvim_create_augroup("global_indent", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = "*",
                callback = function()
                    vim.opt_local.tabstop = 4
                    vim.opt_local.shiftwidth = 4
                    vim.opt_local.softtabstop = 4
                    vim.opt_local.expandtab = true
                end,
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = {
            enable = true,
            max_lines = 3,
            trim_scope = "outer",
            mode = "cursor",
        },
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },

        config = function()
            require("render-markdown").setup({
                latex = { enabled = false },
                html = { enabled = false },
            })
        end,
    },
}

