--[[
Treesitter text objects and movement:

Text Objects:
af -> Select entire function
if -> Select inside function
ac -> Select entire class
ic -> Select inside class

Usage examples:
vaf  -> Visually select a function
yif  -> Yank (copy) inside of function
daf  -> Delete a function
cic  -> Change inside class

Movement:
]m   -> Jump to next function
[m   -> Jump to previous function
]]

return {
    {
        -- Treesitter: syntax highlighting, indentation, and text objects
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",

        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },

        config = function()
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
                    "javascript",
                    "typescript",
                    "typst",
                },

                sync_install = false,

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

            -- Modern augroup API (cleaner)
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

    -- Sticky Context Header (THIS FIXES YOUR PROBLEM)
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = {
            enable = true,
            max_lines = 3, -- show up to 3 context lines
            trim_scope = "outer",
            mode = "cursor", -- show context of current cursor location
        },
    },

    -- Markdown Renderer
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

