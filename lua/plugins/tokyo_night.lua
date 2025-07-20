return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,

	config = function()
		require("tokyonight").setup({
			style = "moon", -- available: 'storm', 'night', 'moon', 'day'
			transparent = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
			},
		})

		vim.cmd("colorscheme tokyonight")
	end,
}
