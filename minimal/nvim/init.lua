vim.g.mapleader = " "

vim.cmd.colorscheme("habamax")

-- Custom Keymaps
vim.keymap.set("n", "<leader>r", "<cmd>update<CR><cmd>source %<CR>")
vim.keymap.set("n", "<leader>.", ":@:<CR>")
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")
vim.keymap.set("n", "<leader>x", "<cmd>x<CR>")
vim.keymap.set("n", "<leader>Q", "<cmd>q!<CR>")
vim.keymap.set("n", "<leader>Y", "<cmd>%y+<CR>")
vim.keymap.set("n", "<leader>D", "<cmd>%d<CR>")
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader><leader>", "<cmd>Oil<CR>")
vim.keymap.set("n", "<leader>p", "<cmd>ToggleTerm<CR>")
vim.keymap.set("n", "<leader>c", "<cmd>CsvViewToggle<CR>")
vim.keymap.set("n", "<CA-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<CA-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<CA-j>", ":m '>+1<CR>gv=gv")

-- General Editor Settings
vim.opt.mouse = "a"
vim.opt.updatetime = 250
vim.opt.colorcolumn = { "120" }
vim.opt.breakindent = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 10
vim.opt.showmode = false

-- Indentation / Tabs
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search Behavior
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- File Handling
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
local undodir = vim.fn.expand("/root/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir

-- Plugins
require("config.lazy")

-- Git branch caching for performance
local branch_cache = {}
local function git_branch()
    local buf = vim.api.nvim_get_current_buf()
    if branch_cache[buf] then
        return branch_cache[buf]
    end
    local dir = vim.fn.expand("%:p:h")
    if dir == "" or vim.fn.isdirectory(dir) == 0 then
        return "~"
    end
    local cmd = "git -C " .. vim.fn.fnameescape(dir) .. " rev-parse --abbrev-ref HEAD 2>/dev/null"
    local branch = vim.fn.trim(vim.fn.system(cmd))
    branch_cache[buf] = branch ~= "" and branch or "~"
    return branch_cache[buf]
end
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    callback = function()
        branch_cache[vim.api.nvim_get_current_buf()] = nil
    end,
})

-- Restore cursor to last position when reopening a file
local restore_cursor = vim.api.nvim_create_augroup("RestoreCursor", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
	group = restore_cursor,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line_count = vim.api.nvim_buf_line_count(0)

		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})
