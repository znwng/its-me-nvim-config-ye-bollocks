return {
	-- Other plugins...
	{
		"ellisonleao/glow.nvim",
		config = function()
			require("glow").setup({
				-- Optional configurations for glow
				border = true, -- Add a border around the preview
				width = 100, -- Set width of the preview
				height = 20, -- Set height of the preview
			})
		end,
	},
}
