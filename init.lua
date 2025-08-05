-- UI
vim.opt.termguicolors = true
vim.opt.colorcolumn = "100"
vim.opt.signcolumn = "yes"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.o.mouse = "a"

-- Tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.autoindent = true

-- idk what to name this section
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Transparent background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- Statusline highlights
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#232136", fg = "#e0def4" }) -- base bg, text fg
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "#6e6a86" }) -- muted
vim.api.nvim_set_hl(0, "StatusLineError", { bg = "NONE", fg = "#eb6f92" }) -- love
vim.api.nvim_set_hl(0, "StatusLineWarn", { bg = "NONE", fg = "#f6c177" }) -- gold
vim.api.nvim_set_hl(0, "StatusLineHint", { bg = "NONE", fg = "#9ccfd8" }) -- foam
vim.api.nvim_set_hl(0, "StatusLineInfo", { bg = "NONE", fg = "#31748f" }) -- iris

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

