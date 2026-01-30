--[[
Telescope.nvim (fuzzy finder)

Keymaps:
<leader>ff -> Find files (shows hidden files too)
<leader>fg -> Live grep
<leader>fb -> Open buffers list
<leader>fh -> Help tags

Buffer navigation:
<Tab>     -> Next buffer
<S-Tab>   -> Previous buffer
]]

return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        config = function()
            -- === Vague-style palette ===
            local colors = {
                bg = "NONE", -- transparent
                bg2 = "#2a2a2a", -- subtle selection surface
                fg = "#d0d0d0", -- primary text
                accent = "#61ffe8", -- active / match highlight
                border = "#5a5a5a", -- muted borders
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

            -- Telescope highlights (Vague-aligned)
            vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = colors.bg, fg = colors.fg })
            vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = colors.bg, fg = colors.border })
            vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = colors.bg, fg = colors.border })
            vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = colors.bg, fg = colors.fg })
            vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = colors.accent })
            vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = colors.bg2 })
            vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = colors.accent, bold = true })
            vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = colors.accent, bold = true })

            -- Keymaps
            local keymap = vim.keymap.set
            local opts = { noremap = true, silent = true }

            keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
            keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
            keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
            keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

            -- Buffer navigation
            keymap("n", "<Tab>", "<cmd>bnext<CR>", opts)
            keymap("n", "<S-Tab>", "<cmd>bprevious<CR>", opts)
        end,
    },
}

