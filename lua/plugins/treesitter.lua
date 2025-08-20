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
        -- Plugin: nvim-treesitter (Better syntax highlighting & parsing)
        "nvim-treesitter/nvim-treesitter",

        -- Keep Treesitter parsers up to date
        build = ":TSUpdate",

        -- Add-on for text objects (functions, classes, etc.)
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },

        config = function()
            require("nvim-treesitter.configs").setup({
                -- Parsers to install
                ensure_installed = {
                    "python",
                    "c",
                    "cpp",
                    "lua",
                    "markdown",
                    "markdown_inline",
                },

                -- Install parsers asynchronously
                sync_install = false,

                -- Enable syntax highlighting
                highlight = {
                    enable = true,
                    disable = {},
                },

                -- Enable smart indentation
                indent = {
                    enable = true,
                },

                -- Extra functionality (text objects & movement)
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump to next textobj
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },

                    move = {
                        enable = true,
                        set_jumps = true, -- Add movements to jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                        },
                    },
                },
            })

            -- Global indentation settings (4 spaces, no tabs)
            vim.api.nvim_exec(
                [[
        augroup global_indent
          autocmd!
          autocmd FileType * setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        augroup END
        ]],
                false
            )
        end,
    },

    {
        -- Plugin: render-markdown (Prettifies Markdown in Neovim)
        "MeanderingProgrammer/render-markdown.nvim",

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },

        config = function()
            require("render-markdown").setup({
                latex = { enabled = false }, -- disable LaTeX rendering
                html = { enabled = false },  -- disable inline HTML rendering
            })
        end,
    },
}

