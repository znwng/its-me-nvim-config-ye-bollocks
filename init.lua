-- UI settings

vim.opt.termguicolors = true -- Enable 24-bit RGB color in the terminal
vim.opt.colorcolumn = "100" -- Show a vertical line column (visual guide)
vim.opt.signcolumn = "yes" -- Always show the sign column (for git/LSP signs etc.)
vim.opt.number = true -- Show absolute line number on the current line
vim.opt.relativenumber = true -- Show relative line numbers on all other lines
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor when scrolling
vim.o.mouse = "a" -- Enable mouse support in all modes

-- Tab and indentation behavior

vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.tabstop = 4 -- Number of spaces a <Tab> equals to
vim.opt.softtabstop = 4 -- Number of spaces used while editing
vim.opt.shiftwidth = 4 -- Number of spaces used for each level of indentation
vim.opt.smartindent = true -- Smart autoindentation for new lines
vim.opt.autoindent = true -- Copy indentation from current line when starting a new one

-- File history and backups

vim.opt.swapfile = false -- Don't create a swap file (tmp editing file)
vim.opt.backup = false -- Don't create backup files
vim.opt.undofile = true -- Enable persistent undo (survives file close)
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Set undo history directory

-- Transparent background highlights

vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) -- Make main editing area transparent
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" }) -- Make inactive window transparent
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" }) -- Transparent popup menu
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" }) -- Transparent floating window borders

-- Statusline highlight groups

vim.api.nvim_set_hl(0, "StatusLine", { bg = "#232136", fg = "#e0def4" }) -- Main statusline
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "#6e6a86" }) -- Inactive statusline
vim.api.nvim_set_hl(0, "StatusLineError", { bg = "NONE", fg = "#eb6f92" }) -- Red for error count
vim.api.nvim_set_hl(0, "StatusLineWarn", { bg = "NONE", fg = "#f6c177" }) -- Yellow for warning count
vim.api.nvim_set_hl(0, "StatusLineHint", { bg = "NONE", fg = "#9ccfd8" }) -- Teal for hint count
vim.api.nvim_set_hl(0, "StatusLineInfo", { bg = "NONE", fg = "#31748f" }) -- Blue for info count

-- Function: count diagnostics of a given severity for current buffer
function _G.diag_count(severity)
	local diags = vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity:upper()] })
	return #diags
end

-- Custom statusline layout
vim.opt.statusline = "%{expand('%:p')} %m %=" -- Full file path + modified flag
	.. "%#StatusLineError#E:%{v:lua.diag_count('Error')} " -- Error count (red)
	.. "%#StatusLineWarn#W:%{v:lua.diag_count('Warn')} " -- Warning count (yellow)
	.. "%#StatusLineHint#H:%{v:lua.diag_count('Hint')} " -- Hint count (teal)
	.. "%#StatusLineInfo#I:%{v:lua.diag_count('Info')} " -- Info count (blue)
	.. "%#StatusLine#[%l:%c]" -- Cursor position [line:col]

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
		vim.highlight.on_yank({ timeout = 200 }) -- 200ms highlight
	end,
})

-- Restore cursor to last position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"') -- Last cursor mark
		local lcount = vim.api.nvim_buf_line_count(0) -- Total lines in file
		if mark[1] > 0 and mark[1] <= lcount then
			vim.api.nvim_win_set_cursor(0, mark) -- Restore position if valid
		end
	end,
})

