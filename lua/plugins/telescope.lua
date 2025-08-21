--[[
Plugin: Telescope.nvim
Description: Fuzzy finder for files, buffers, grep, and more.

Keybindings:
  <leader>ff -> Find files (includes hidden files)
  <leader>fg -> Live grep
  <leader>fb -> List open buffers
  <leader>fh -> Help tags

Buffer navigation:
  <Tab>     -> Next buffer
  <S-Tab>   -> Previous buffer
]]

return {
    {
        -- Plugin: telescope.nvim — Highly extendable fuzzy finder for Neovim
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",

        -- Required dependencies
        dependencies = {
            "nvim-lua/plenary.nvim", -- Utilities for Telescope
            "catppuccin/nvim",       -- Theme integration
        },

        config = function()
            -- Telescope setup with defaults and picker options
            require("telescope").setup({
                defaults = {
                    prompt_prefix = " ", -- Minimal prompt prefix
                    selection_caret = " ", -- Arrow for selected item
                    sorting_strategy = "ascending", -- Results start at the top
                    layout_config = { prompt_position = "top" },
                    winblend = 10, -- Slight transparency
                    border = true,
                    color_devicons = true, -- Show colored icons
                },
                pickers = {
                    find_files = { hidden = true }, -- Include dotfiles
                },
            })

            -- Catppuccin theme integration for Telescope
            require("catppuccin").setup({
                integrations = { telescope = true },
            })

            -- Transparent backgrounds for Telescope windows
            local group = vim.api.nvim_create_augroup("TelescopeBackground", { clear = true })
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = group,
                pattern = "catppuccin",
                callback = function()
                    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
                    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE" })
                    vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#1f1f1f" })
                end,
            })

            -- Keymaps for Telescope actions
            local keymap = vim.keymap.set
            local opts = { noremap = true, silent = true }

            keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
            keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
            keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
            keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

            -- Simple buffer navigation keymaps
            keymap("n", "<Tab>", "<cmd>bnext<CR>", opts)
            keymap("n", "<S-Tab>", "<cmd>bprevious<CR>", opts)
        end,
    },
}

