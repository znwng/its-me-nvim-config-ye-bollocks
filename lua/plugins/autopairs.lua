--[[
Keybinds:
This plugin works automatically and does not require explicit keybindings.
However, it integrates with <CR> (Enter key) for smart pairing inside brackets.
]]

return {
	{
		-- Plugin: nvim-autopairs — auto-closes brackets, quotes, etc.
		"windwp/nvim-autopairs",

		-- Lazy-load the plugin only when entering Insert mode
		event = "InsertEnter",

		config = function()
			require("nvim-autopairs").setup({
				-- Use Treesitter to detect language-specific pair rules
				check_ts = true,

				-- Disable autopairs for these specific filetypes
				disable_filetype = { "TelescopePrompt", "vim" },
			})
		end,
	},
}

