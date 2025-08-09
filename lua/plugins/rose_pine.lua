return {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false,
	priority = 1000,

	config = function()
		require("rose-pine").setup({
			variant = "moon", -- options: 'main' (default), 'moon', 'dawn'
			disable_background = true,
			styles = {
				italic = false,
				bold = false,
			},
		})

		vim.cmd.colorscheme("rose-pine")
	end,
}

