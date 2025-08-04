-- UI
vim.opt.termguicolors = true
vim.opt.colorcolumn = "100"
vim.opt.signcolumn = "yes"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.o.mouse = "a"

-- Transparent background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- Statusline highlights
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#181825", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "#808080" })
vim.api.nvim_set_hl(0, "StatusLineError", { bg = "NONE", fg = "#ff5555" })
vim.api.nvim_set_hl(0, "StatusLineWarn", { bg = "NONE", fg = "#ffff43" })
vim.api.nvim_set_hl(0, "StatusLineHint", { bg = "NONE", fg = "#55ffe3" })
vim.api.nvim_set_hl(0, "StatusLineInfo", { bg = "NONE", fg = "#54ff3c" })

-- Diagnostic count
function _G.diag_count(severity)
	local diags = vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity:upper()] })
	return #diags
end

-- Statusline format
vim.opt.statusline = "%{expand('%:p')} %m %="
	.. "%#StatusLineError#E:%{v:lua.diag_count('Error')} "
	.. "%#StatusLineWarn#W:%{v:lua.diag_count('Warn')} "
	.. "%#StatusLineHint#H:%{v:lua.diag_count('Hint')} "
	.. "%#StatusLineInfo#I:%{v:lua.diag_count('Info')} "
	.. "%#StatusLine#[%l:%c]"

-- Plugins
require("config.lazy")

-- Restore transparency on colorscheme change
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

-- Yank flash
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})
