vim.g.mapleader = " "

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
vim.keymap.set("v", "<CA-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<leader>n", function()
    if vim.o.wrap then
        vim.o.wrap = false
        vim.notify("Word wrap: OFF", vim.log.levels.INFO)
    else
        vim.o.wrap = true
        vim.notify("Word wrap: ON", vim.log.levels.INFO)
    end
end, { desc = "Toggle word wrap" })
vim.keymap.set("n", "<leader>m", function()
    if vim.o.mouse ~= "" then
        vim.o.mouse = ""
        vim.notify("Mouse support: OFF", vim.log.levels.INFO)
    else
        vim.opt.mouse = "a"
        vim.notify("Mouse support: ON", vim.log.levels.INFO)
    end
end, { desc = "Toggle mouse support" })

-- General Editor Settings
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.colorcolumn = { "120" }
vim.opt.breakindent = true
vim.opt.signcolumn = "yes"
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.showmode = false
vim.opt.cursorline = true

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
    git_branch = git_branch,
}

_G._statusline.mode = function()
    local m = vim.api.nvim_get_mode().mode
    local map = {
        n = "NR",
        i = "IN",
        v = "VS",
        V = "VL",
        ["\22"] = "VB",
        c = "CD",
        R = "RP",
        t = "TR",
    }
    return map[m] or m
end

_G._statusline.line_count = function()
    return vim.api.nvim_buf_line_count(0)
end

vim.o.statusline = table.concat({
    "%#StatusLineMode#",
    "[%{v:lua._statusline.mode()}] ",
    "%#StatusLinePath#%{expand('%:p:~')} ",
    "%#StatusLineBranch#[%{v:lua._statusline.git_branch()}] ",
    "%m %=",
    "%#StatusLineError#E%{v:lua._statusline.diag_count('ERROR')} ",
    "%#StatusLineWarn#W%{v:lua._statusline.diag_count('WARN')} ",
    "%#StatusLineHint#H%{v:lua._statusline.diag_count('HINT')} ",
    "%#StatusLineLines#[%{v:lua._statusline.line_count()}] ",
    "%#StatusLineCur#[%l:%c]%#StatusLine#",
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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "make",
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

-- Formatting helpers
function _G.format_buffer()
    if vim.lsp.buf.server_ready() then
        vim.lsp.buf.format({
            async = true,
        })
    end
end

-- Define a custom highlight group for yank
vim.api.nvim_set_hl(0, "YankHighlight", {
    fg = nil,
    bg = "#252525",
    bold = true,
    underline = false,
})

-- Highlight yanked text using the custom group
vim.api.nvim_set_hl(0, "YankHighlight", {
    fg = "#1a1b26",
    bg = "#7aa2f7",
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({
            higroup = "YankHighlight",
            timeout = 200,
        })
    end,
})
