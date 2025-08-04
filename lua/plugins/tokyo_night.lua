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
				comments = "italic",
				keywords = "italic",
			},
		})

		vim.cmd.colorscheme("rose-pine")
	end,
}
