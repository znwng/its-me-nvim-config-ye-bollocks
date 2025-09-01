--[[
Keybindings for Treesitter text objects:

Text Objects:
af -> Select entire function
if -> Select inside function
ac -> Select entire class
ic -> Select inside class

Usage examples:
- vaf  -> Visually select an entire function
- yif  -> Yank (copy) the inside of a function
- daf  -> Delete an entire function
- cic  -> Change inside class

Movement:
]m   -> Jump to next function
[m   -> Jump to previous function
]]

return {
    {
        -- Plugin: nvim-treesitter — Syntax highlighting, indentation, and text objects
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",

        -- Textobject support dependency
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },

        config = function()
            require("nvim-treesitter.configs").setup({
                -- Languages to install parsers for
                ensure_installed = {
                    "python",
                    "c",
                    "cpp",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "rust",
                    "java",
                    "javascript",
                    "typescript",
                },

                sync_install = false, -- Install parsers asynchronously

                -- Highlighting configuration
                highlight = {
                    enable = true,
                    disable = {},
                },

                -- Indentation based on Treesitter
                indent = {
                    enable = true,
                },

                -- Textobjects configuration
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobject
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- Record jumps in jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                        },
                    },
                },
            })

            -- Global indentation settings (4 spaces, expand tabs)
            vim.api.nvim_exec([[
                augroup global_indent
                  autocmd!
                  autocmd FileType * setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
                augroup END
            ]], false)
        end,
    },

    {
        -- Plugin: render-markdown.nvim — Render Markdown directly in Neovim
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },

        config = function()
            require("render-markdown").setup({
                latex = { enabled = false }, -- Disable LaTeX rendering
                html = { enabled = false },  -- Disable HTML rendering
            })
        end,
    },
}

