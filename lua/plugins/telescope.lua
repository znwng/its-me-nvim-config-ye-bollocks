return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"catppuccin/nvim",
		},
		config = function()
			require("telescope").setup({
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					sorting_strategy = "ascending",
					layout_config = { prompt_position = "top" },
					winblend = 10,
					border = true,
					color_devicons = true,
				},
				pickers = {
					find_files = { hidden = true },
				},
			})

			require("catppuccin").setup({
				integrations = {
					telescope = true,
				},
			})

			-- Replaces vim.cmd augroup
			vim.api.nvim_create_augroup("TelescopeBackground", { clear = true })
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = "TelescopeBackground",
				pattern = "catppuccin",
				callback = function()
					vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
					vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE" })
					vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#1f1f1f" })
				end,
			})

			-- Telescope keybindings
			local keymap = vim.api.nvim_set_keymap
			local opts = { noremap = true, silent = true }
			keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
			keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
			keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
			keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

			-- Buffer nav
			keymap("n", "<Tab>", ":bnext<CR>", opts)
			keymap("n", "<S-Tab>", ":bprevious<CR>", opts)
		end,
	},
}

