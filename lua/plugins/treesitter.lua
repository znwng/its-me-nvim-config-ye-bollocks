--[[
Keybindings for Treesitter text objects:

af -> Select entire function
if -> Select inside function
ac -> Select entire class
ic -> Select inside class

Usage examples:
- vaf  -> Visually select an entire function
- yif  -> Yank (copy) the inside of a function
- daf  -> Delete an entire function
- cic  -> Change inside class
- ]m   -> Jump to next function
- [m   -> Jump to previous function
]]

return {
	{
		-- Plugin: nvim-treesitter (Better syntax highlighting & parsing)
		"nvim-treesitter/nvim-treesitter",

		run = ":TSUpdate",

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
				},

				sync_install = false,

				highlight = {
					enable = true,
					disable = {},
				},

				indent = {
					enable = true,
				},

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
						set_jumps = true, -- Add to jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
						},
					},
				},
			})

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

