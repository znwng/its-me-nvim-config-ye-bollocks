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
vim.g.mapleader = " " -- Space as leader
vim.g.maplocalleader = "\\" -- Backslash as local leader

-- Configure lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" }, -- Load plugins from plugins/ folder
	},
	install = { colorscheme = {} },
	checker = { enabled = true, notify = false },
	change_detection = { notify = true },
	ui = {
		border = "rounded", -- Rounded border for Lazy UI
		winblend = 0, -- Opaque
	},
})

-- ================================================================
-- Post-Lazy UI Enhancements: Borders and Float Colors for All UIs
-- ================================================================

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy", -- Trigger after Lazy finishes loading plugins
	callback = function()
		-- Gruvbox-style float and border colors
		local border_color = "#fabd2f" -- bright yellow
		local bg_color = "" -- dark background

		-- Apply consistent float styling
		vim.api.nvim_set_hl(0, "FloatBorder", { fg = border_color, bg = bg_color })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg_color })

		-- Mason border
		local ok_mason, mason = pcall(require, "mason")
		if ok_mason then
			mason.setup({
				ui = { border = "rounded" },
			})
		end

		-- Telescope border
		local ok_telescope, telescope = pcall(require, "telescope")
		if ok_telescope then
			telescope.setup({
				defaults = {
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					layout_config = {
						prompt_position = "top",
					},
				},
			})
		end

		-- LSP popups (hover, signature help) border
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
		vim.lsp.handlers["textDocument/signatureHelp"] =
			vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
	end,
})

