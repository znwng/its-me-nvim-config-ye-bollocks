-- Enable true color support
vim.opt.termguicolors = true

-- UI settings
vim.opt.number = true -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.scrolloff = 6 -- Keep at least 6 lines above/below the cursor

-- Enable mouse
vim.o.mouse = "a"

-- Transparent background highlights
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- Custom statusline highlight groups (no backgrounds, just text color)
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#181825", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "#808080" })
vim.api.nvim_set_hl(0, "StatusLineError", { bg = "NONE", fg = "#ff5555" })
vim.api.nvim_set_hl(0, "StatusLineWarn", { bg = "NONE", fg = "#ffff43" })
vim.api.nvim_set_hl(0, "StatusLineHint", { bg = "NONE", fg = "#55ffe3" })
vim.api.nvim_set_hl(0, "StatusLineInfo", { bg = "NONE", fg = "#54ff3c" })

-- Diagnostic count helper
function _G.diag_count(severity)
	local diags = vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity:upper()] })
	return #diags
end

-- Final statusline string (with full file path)
vim.opt.statusline = "%{expand('%:p')} %m %="
	.. "%#StatusLineError#E:%{v:lua.diag_count('Error')} "
	.. "%#StatusLineWarn#W:%{v:lua.diag_count('Warn')} "
	.. "%#StatusLineHint#H:%{v:lua.diag_count('Hint')} "
	.. "%#StatusLineInfo#I:%{v:lua.diag_count('Info')} "
	.. "%#StatusLine#[%l:%c]"

-- Load Lazy.nvim plugin manager configuration
require("config.lazy")

-- Fix popup menu border bg (must come after colorscheme loads)
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
