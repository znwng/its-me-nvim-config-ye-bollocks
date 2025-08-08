-- UI settings
vim.opt.termguicolors = true
vim.opt.colorcolumn = "100"
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.o.mouse = "a"

-- Tab and indentation behavior (tab gang rise)
vim.opt.expandtab = false -- actual tabs, not spaces
vim.opt.tabstop = 4 -- a tab = 4 spaces (visually)
vim.opt.softtabstop = 0 -- tab/backspace are 1 tab character
vim.opt.shiftwidth = 4 -- auto-indent = 1 tab
vim.opt.smartindent = true
vim.opt.autoindent = true

-- File history and backups
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Transparent background highlights
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- Statusline highlight groups
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#232136", fg = "#e0def4" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "#6e6a86" })
vim.api.nvim_set_hl(0, "StatusLineError", { bg = "NONE", fg = "#eb6f92" })
vim.api.nvim_set_hl(0, "StatusLineWarn", { bg = "NONE", fg = "#f6c177" })
vim.api.nvim_set_hl(0, "StatusLineHint", { bg = "NONE", fg = "#9ccfd8" })
vim.api.nvim_set_hl(0, "StatusLineInfo", { bg = "NONE", fg = "#31748f" })

-- Function: count diagnostics of a given severity for current buffer
function _G.diag_count(severity)
	local diags = vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity:upper()] })
	return #diags
end

-- Custom statusline layout
vim.opt.statusline = "%{expand('%:p')} %m %="
	.. "%#StatusLineError#E:%{v:lua.diag_count('Error')} "
	.. "%#StatusLineWarn#W:%{v:lua.diag_count('Warn')} "
	.. "%#StatusLineHint#H:%{v:lua.diag_count('Hint')} "
	.. "%#StatusLineInfo#I:%{v:lua.diag_count('Info')} "
	.. "%#StatusLine#[%l:%c]"

-- Load plugins from 'config.lazy' module
require("config.lazy")

-- Automatically restore transparency when colorscheme is changed
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

-- Highlight yanked text briefly (like VSCode flash)
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

-- Restore cursor to last position when reopening a file
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

-- Autoformat before save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local last_line = vim.api.nvim_buf_get_lines(0, -2, -1, false)[1]
		if last_line ~= "" then
			vim.api.nvim_buf_set_lines(0, -1, -1, false, { "" })
		end
	end,
})

