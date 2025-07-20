return {
	{
		"norcalli/nvim-colorizer.lua", -- highlights CSS colors
		config = function()
			require("colorizer").setup()
		end,
	},
}
