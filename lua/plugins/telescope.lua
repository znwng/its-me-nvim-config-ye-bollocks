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
		-- Telescope: fuzzy finder (files, grep, buffers, etc.)
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",

		-- Needed dependencies
		dependencies = {
			"nvim-lua/plenary.nvim", -- Telescope utilities
			"catppuccin/nvim", -- Theme integration
		},

		config = function()
			-- Telescope defaults
			require("telescope").setup({
				defaults = {
					prompt_prefix = " ", -- Clean prompt
					selection_caret = "|>", -- Arrow for current item
					sorting_strategy = "ascending", -- Results at top
					layout_config = { prompt_position = "bottom" },
					winblend = 0, -- No transparency
					border = true,
					color_devicons = true, -- Colored file icons
				},
				pickers = {
					find_files = { hidden = true }, -- Show dotfiles
				},
			})

			-- Theme integration (Catppuccin)
			require("rose-pine").setup({
				integrations = { telescope = true },
			})

			-- Transparent background for Telescope popups
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

			-- Keymaps for Telescope
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

