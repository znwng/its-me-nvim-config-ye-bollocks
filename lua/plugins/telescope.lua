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
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "catppuccin/nvim", -- Theme integration
        },
        config = function()
            -- Telescope setup
            require("telescope").setup({
                defaults = {
                    prompt_prefix = " ", -- No prefix clutter
                    selection_caret = " ", -- Arrow indicator
                    sorting_strategy = "ascending", -- Results on top
                    layout_config = { prompt_position = "top" },
                    winblend = 10, -- Slight transparency
                    border = true,
                    color_devicons = true, -- Colored filetype icons
                },
                pickers = {
                    find_files = { hidden = true }, -- Show dotfiles
                },
            })

            -- Telescope + Catppuccin theme integration
            require("catppuccin").setup({
                integrations = {
                    telescope = true,
                },
            })

            -- Transparent backgrounds for Telescope
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

            -- Telescope keymaps
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

