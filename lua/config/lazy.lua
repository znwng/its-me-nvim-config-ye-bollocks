--[[
lazy.lua
Sets up the plugin manager (lazy.nvim)
(This file only handles plugins, not keymaps or general settings)
]]

-- Folder where lazy.nvim will be installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- If lazy.nvim is not installed, clone it from GitHub
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})

	-- Show error and exit if git clone fails
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Could not install lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Add lazy.nvim to Neovim’s runtime path
vim.opt.rtp:prepend(lazypath)

-- Define leader keys before loading plugins
vim.g.mapleader = " " -- Use Space as leader
vim.g.maplocalleader = "\\" -- Use Backslash as local leader

-- Configure lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" }, -- Load plugins from plugins/ folder
	},
	install = { colorscheme = {} }, -- Do not set a default colorscheme here
	checker = { enabled = true, notify = false }, -- Auto check for plugin updates in background
	change_detection = { notify = true }, -- Warn if config files change
	ui = { border = "none", winblend = 0 }, -- Simple UI (no borders, no transparency)
})

