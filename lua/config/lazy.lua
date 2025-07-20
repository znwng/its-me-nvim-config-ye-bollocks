--[[
Keybindings:
(No keybindings required; lazy.nvim is a plugin manager and runs automatically.)
]]

-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is installed, and clone if missing
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

	-- Handle errors in cloning lazy.nvim
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Prepend lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Set leader keys before loading lazy.nvim
vim.g.mapleader = " " -- Space as leader key
vim.g.maplocalleader = "\\" -- Backslash as local leader key

-- Setup lazy.nvim with configurations
require("lazy").setup({
	spec = {
		{ import = "plugins" }, -- Import plugin definitions from the plugins/ directory
	},
	install = { colorscheme = { "catppuccin" } }, -- Set default colorscheme during plugin installation
	checker = { enabled = false }, -- Disable automatic update checking
	change_detection = { notify = true }, -- Enable update notifications
	ui = {
		border = "rounded", -- Use rounded borders for UI popups
	},
})
