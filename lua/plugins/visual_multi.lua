--[[
Keybindings for vim-visual-multi:

<C-n>     → Select next occurrence (keep pressing for more)
<C-p>     → Select previous occurrence
<C-x>     → Skip occurrence
<C-down>  → Add a cursor downward
<C-up>    → Add a cursor upward
Shift + I → Enter Insert mode at all cursors
Shift + A → Enter Append mode at all cursors
Esc       → Exit multi-cursor mode
]]

return {
	{
		-- Plugin: vim-visual-multi (Multi-cursor support for Neovim)
		"mg979/vim-visual-multi",

		-- Use the stable master branch
		branch = "master",
	},
}
