return {
	{
		"windwp/nvim-ts-autotag", -- auto-close HTML tags
		config = function()
			-- Initialize nvim-ts-autotag with the new setup method
			require("nvim-ts-autotag").setup({
				-- This part enables the functionality to automatically close HTML tags
				filetypes = { "html", "javascript", "typescript", "tsx", "css", "xml" }, -- Specify filetypes explicitly
			})
		end,
	},
}
