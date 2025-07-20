--[[
Keybindings for Comment.nvim:

gcc        -> Toggle comment for the current line
gbc        -> Toggle block comment

gc<motion> -> Comment lines using motion (e.g., gcj to comment current + next line)
gb<motion> -> Block comment using motion

gcO        -> Add comment above the current line
gco        -> Add comment below the current line
gcA        -> Add comment at the end of the current line
]]

return {
	{
		-- Plugin: Comment.nvim — Simple, fast commenting for Neovim
		"numToStr/Comment.nvim",

		-- Immediately load the plugin (not lazy-loaded)
		lazy = false,

		-- Plugin configuration using the built-in `opts` pattern
		opts = {
			toggler = {
				line = "gcc", -- Keybinding to toggle line comment
				block = "gbc", -- Keybinding to toggle block comment
			},
			opleader = {
				line = "gc", -- Operator-pending mode for line comments (e.g., `gcj`)
				block = "gb", -- Operator-pending mode for block comments
			},
			extra = {
				above = "gcO", -- Add a comment line above the current line
				below = "gco", -- Add a comment line below the current line
				eol = "gcA", -- Add a comment at the end of the current line
			},
		},
	},
}
