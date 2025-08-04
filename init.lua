-- Enable full 24-bit color support (required for themes with truecolor palettes)
vim.opt.termguicolors = true

-- Visually mark the 120th column (soft wrap/ruler guide)
vim.opt.colorcolumn = "120"

-- Always show sign column to prevent horizontal shifting when signs appear
vim.opt.signcolumn = "yes"

-- Enable case-insensitive search unless capital letters are used (smart filtering)
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- UI settings: line numbers and scroll margin
vim.opt.number = true -- Show absolute line numbers on the left
vim.opt.relativenumber = true -- Show relative numbers (great for jump motions)
vim.opt.scrolloff = 6 -- Keep 6 lines visible above/below cursor when scrolling

-- Enable mouse support in all modes (useful for terminal resizing, selections)
vim.o.mouse = "a"

-- Set transparent backgrounds for specific UI components (blend with terminal background)
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- Define custom highlight groups for the statusline (color-coded diagnostics, no background fill)
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#181825", fg = "#ffffff" }) -- Active statusline
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "#808080" }) -- Inactive window statusline
vim.api.nvim_set_hl(0, "StatusLineError", { bg = "NONE", fg = "#ff5555" }) -- Errors
vim.api.nvim_set_hl(0, "StatusLineWarn", { bg = "NONE", fg = "#ffff43" }) -- Warnings
vim.api.nvim_set_hl(0, "StatusLineHint", { bg = "NONE", fg = "#55ffe3" }) -- Hints
vim.api.nvim_set_hl(0, "StatusLineInfo", { bg = "NONE", fg = "#54ff3c" }) -- Info messages

-- Global function to count diagnostic messages by severity
function _G.diag_count(severity)
	local diags = vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity:upper()] })
	return #diags
end

-- Custom statusline showing:
--   - full file path
--   - modified indicator
--   - diagnostic counts (E/W/H/I)
--   - current line and column
vim.opt.statusline = "%{expand('%:p')} %m %="
	.. "%#StatusLineError#E:%{v:lua.diag_count('Error')} "
	.. "%#StatusLineWarn#W:%{v:lua.diag_count('Warn')} "
	.. "%#StatusLineHint#H:%{v:lua.diag_count('Hint')} "
	.. "%#StatusLineInfo#I:%{v:lua.diag_count('Info')} "
	.. "%#StatusLine#[%l:%c]"

-- Load Lazy.nvim plugin manager (modular plugin setup lives in 'lua/config/lazy.lua')
require("config.lazy")

-- Re-apply transparent backgrounds after colorscheme changes (important for themes)
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "CmpBorder", { bg = "none" })
		vim.api.nvim_set_hl(0, "CmpDocBorder", { bg = "none" })
		vim.api.nvim_set_hl(0, "CmpDoc", { bg = "none" })
		vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
		vim.api.nvim_set_hl(0, "PmenuSel", { bg = "none", blend = 0 })
		vim.api.nvim_set_hl(0, "PmenuBorder", { bg = "none" })
	end,
})

-- Flash highlight yanked text (visual confirmation of copy/yank)
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})
