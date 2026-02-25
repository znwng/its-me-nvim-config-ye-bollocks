vim.g.mapleader = " "

-- Custom Keymaps
vim.keymap.set("n", "<leader>r", "<cmd>update<CR><cmd>source %<CR>", { desc = "Reload current file" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Write" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>x", "<cmd>x<CR>", { desc = "Write and Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>q!<CR>", { desc = "!Write and Quit" })

-- General Editor Settings
vim.opt.mouse = ""
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.colorcolumn = { "100" }
vim.opt.breakindent = true
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
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
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir

-- Helper Functions
local function diag_count(sev_name)
    local sev = vim.diagnostic.severity[sev_name:upper()]
    if not sev then
        return 0
    end
    local diags = vim.diagnostic.get(0, { severity = sev })
    return #diags
end

local function human_file_size()
    local file = vim.fn.expand("%:p")
    if file == "" or vim.fn.filereadable(file) == 0 then
        return "~"
    end
    local size = vim.fn.getfsize(file)
    if size < 0 then
        return "~"
    end
    if size < 1024 then
        return size .. "B"
    end
    if size < 1024 * 1024 then
        return string.format("%.1fKB", size / 1024)
    end
    if size < 1024 * 1024 * 1024 then
        return string.format("%.1fMB", size / (1024 * 1024))
    end
    return string.format("%.1fGB", size / (1024 * 1024 * 1024))
end

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

-- Statusline Helpers
_G._statusline = {
    diag_count = diag_count,
    human_file_size = human_file_size,
    git_branch = git_branch,
}

_G._statusline.mode = function()
    local m = vim.api.nvim_get_mode().mode
    local map = {
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "V-LINE",
        ["\22"] = "V-BLOCK",
        c = "COMMAND",
        R = "REPLACE",
        t = "TERMINAL",
    }
    return map[m] or m
end

vim.o.statusline = table.concat({
    "%#StatusLineMode#[%{v:lua._statusline.mode()}] %#StatusLine#",
    "%{expand('%:p:~')} ",
    "%#StatusLineBranch#[%{v:lua._statusline.git_branch()}] ",
    "%m %=",
    "%#StatusLineError#%{v:lua._statusline.diag_count('ERROR')} ",
    "%#StatusLineWarn#%{v:lua._statusline.diag_count('WARN')} ",
    "%#StatusLineHint#%{v:lua._statusline.diag_count('HINT')} ",
    "%#StatusLineInfo#%{v:lua._statusline.diag_count('INFO')} ",
    "%#StatusLine#[%{v:lua._statusline.human_file_size()}] ",
    "%#StatusLine#[%l:%c]",
})

-- Plugins
require("config.lazy")

-- Autocommands
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        for _, group in ipairs({
            "CmpBorder",
            "CmpDocBorder",
            "CmpDoc",
            "Pmenu",
            "PmenuSel",
            "PmenuBorder",
        }) do
            vim.api.nvim_set_hl(0, group, { bg = "none" })
        end
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "none", blend = 0 })
    end,
})

vim.api.nvim_set_hl(0, "MatchParen", {
    underline = true,
    bold = false,
    bg = "NONE",
    fg = "NONE",
})

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Formatting helpers
local function ensure_single_trailing_newline(bufnr)
    bufnr = bufnr or 0
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local last_nonempty = line_count
    while last_nonempty > 0 do
        local line = vim.api.nvim_buf_get_lines(bufnr, last_nonempty - 1, last_nonempty, false)[1]
        if line ~= "" then
            break
        end
        last_nonempty = last_nonempty - 1
    end
    vim.api.nvim_buf_set_lines(bufnr, last_nonempty, line_count, false, { "" })
end

function _G.format_buffer()
    if vim.lsp.buf.server_ready() then
        vim.lsp.buf.format({
            async = true,
            callback = function()
                ensure_single_trailing_newline(0)
            end,
        })
    end
end

local netrw_buf = nil
vim.keymap.set("n", "<leader>e", function()
    if netrw_buf and vim.api.nvim_buf_is_valid(netrw_buf) then
        vim.api.nvim_buf_delete(netrw_buf, { force = true })
        netrw_buf = nil
    else
        vim.cmd("Ex")
        netrw_buf = vim.api.nvim_get_current_buf()
    end
end, { desc = "Toggle Netrw" })

