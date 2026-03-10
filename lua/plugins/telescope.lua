return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        config = function()
            local colors = {
                bg = "NONE",
                bg2 = "#2a2a2a",
                fg = "#d0d0d0",
                accent = "#61ffe8",
                border = "#5a5a5a",
            }

            require("telescope").setup({
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    sorting_strategy = "ascending",
                    layout_config = { prompt_position = "top" },
                    winblend = 0,
                    color_devicons = true,
                    border = true,
                    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                },
                pickers = {
                    colorscheme = {
                        enable_preview = true,
                    },
                    find_files = { hidden = true },
                },
            })

            vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = colors.bg, fg = colors.fg })
            vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = colors.bg, fg = colors.border })
            vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = colors.bg, fg = colors.border })
            vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = colors.bg, fg = colors.fg })
            vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = colors.accent })
            vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = colors.bg2 })
            vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = colors.accent, bold = true })
            vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = colors.accent, bold = true })

            local keymap = vim.keymap.set
            local opts = { noremap = true, silent = true }

            keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
            keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
            keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
            keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

            keymap("n", "<Tab>", "<cmd>bnext<CR>", opts)
            keymap("n", "<S-Tab>", "<cmd>bprevious<CR>", opts)
        end,
    },
}

