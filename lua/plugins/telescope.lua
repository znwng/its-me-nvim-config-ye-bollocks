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
                panel = "#2a2a2b",
                fg = "#d0d0d0",
                accent = "#61ffe8",
                border = "#5a5a5a",
            }
            require("telescope").setup({
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    sorting_strategy = "ascending",
                    layout_config = {
                        prompt_position = "top",
                    },
                    winblend = 0,
                    border = true,
                    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                },
                pickers = {
                    find_files = { hidden = true },
                },
            })
            local function apply_telescope_hl()
                local set = vim.api.nvim_set_hl
                set(0, "TelescopeNormal", { bg = colors.bg, fg = colors.fg })
                set(0, "TelescopeResultsNormal", { bg = colors.bg, fg = colors.fg })
                set(0, "TelescopePromptNormal", { bg = colors.bg, fg = colors.fg })
                set(0, "TelescopePromptPrefix", { fg = colors.accent })
                set(0, "TelescopePromptTitle", { fg = colors.accent })
                set(0, "TelescopeBorder", { bg = colors.bg, fg = colors.border })
                set(0, "TelescopePromptBorder", { bg = colors.bg, fg = colors.border })
                set(0, "TelescopeResultsBorder", { bg = colors.bg, fg = colors.border })
                set(0, "TelescopeSelection", { bg = colors.panel })
                set(0, "TelescopeSelectionCaret", { fg = colors.accent, bold = true })
                set(0, "TelescopeMatching", { fg = colors.accent, bold = true })
            end
            apply_telescope_hl()
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = apply_telescope_hl,
            })
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

