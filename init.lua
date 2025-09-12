-- General editor settings
vim.o.mouse            = "a"                                      -- Enable mouse
vim.opt.termguicolors  = true                                     -- Enable true color
vim.opt.updatetime     = 250                                      -- Faster update time
vim.opt.colorcolumn    = "100"                                    -- Vertical line at column 100
vim.opt.breakindent    = true                                     -- Keep indent on wrapped lines
vim.opt.signcolumn     = "yes"                                    -- Always show sign column
vim.opt.number         = true                                     -- Show line numbers
vim.opt.relativenumber = true                                     -- Show relative line numbers
vim.opt.scrolloff      = 10                                       -- Keep 10 lines visible when scrolling
vim.opt.expandtab      = false                                    -- Use tabs instead of spaces
vim.opt.tabstop        = 4                                        -- Tab size = 4
vim.opt.shiftwidth     = 4                                        -- Indent size = 4
vim.opt.smartindent    = true                                     -- Smart auto-indent
vim.opt.autoindent     = true                                     -- Copy indent from current line
vim.opt.incsearch      = true                                     -- Show matches while typing search
vim.opt.ignorecase     = true                                     -- Ignore case in search
vim.opt.smartcase      = true                                     -- Override ignorecase if uppercase present
vim.opt.hlsearch       = true                                     -- Highlight search matches
vim.opt.swapfile       = false                                    -- Disable swap files
vim.opt.backup         = false                                    -- Disable backup files
vim.opt.undofile       = true                                     -- Enable persistent undo
vim.opt.undodir        = { os.getenv("HOME") .. "/.vim/undodir" } -- Undo directory

-- Helper functions

-- Count diagnostics by severity
function _G.diag_count(severity)
    local sev = vim.diagnostic.severity[severity:upper()]
    local diags = vim.diagnostic.get(0, { severity = sev })
    return #diags
end

-- Get human readable file size
function _G.human_file_size()
    local file = vim.fn.expand("%:p")
    if file == "" or vim.fn.filereadable(file) == 0 then return "~" end
    local size = vim.fn.getfsize(file)
    if size < 0 then
        return "~"
    elseif size < 1024 then
        return size .. "B"
    elseif size < 1024 * 1024 then
        return string.format("%.1fKB", size / 1024)
    elseif size < 1024 * 1024 * 1024 then
        return string.format("%.1fMB", size / (1024 * 1024))
    else
        return string.format("%.1fGB", size / (1024 * 1024 * 1024))
    end
end

-- Get git branch or [~]
function _G.git_branch()
    local gitdir = vim.fn.finddir(".git", vim.fn.expand("%:p:h") .. ";")
    if gitdir == "" then return "[~]" end
    local branch = vim.fn.system("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --abbrev-ref HEAD 2>/dev/null")
    branch = vim.fn.trim(branch)
    if branch == "" then return "[~]" end
    return "[" .. branch .. "]"
end

-- Custom statusline
vim.o.statusline = table.concat({
    "%{expand('%:p')} ",                               -- File path
    "%{v:lua.git_branch()} ",                          -- Git branch
    "%m %=",                                           -- Modified flag
    "%#StatusLineError#%{v:lua.diag_count('Error')} ", -- Error count
    "%#StatusLineWarn#%{v:lua.diag_count('Warn')} ",   -- Warning count
    "%#StatusLineHint#%{v:lua.diag_count('Hint')} ",   -- Hint count
    "%#StatusLineInfo#%{v:lua.diag_count('Info')} ",   -- Info count
    "%#StatusLine#[%{v:lua.human_file_size()}] ",      -- File size
    "%#StatusLine#[%l:%c]",                            -- Line and column
})

-- Plugins
require("config.lazy") -- Load plugin manager

-- Autocommands

-- Make popups transparent on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        for _, group in ipairs({ "CmpBorder", "CmpDocBorder", "CmpDoc", "Pmenu", "PmenuSel", "PmenuBorder" }) do
            vim.api.nvim_set_hl(0, group, { bg = "none" })
        end
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "none", blend = 0 })
    end,
})

-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
})

-- Restore cursor position when reopening file
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Auto-format before save
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        if vim.lsp.buf.format then
            pcall(vim.lsp.buf.format, { async = false })
        end
    end,
})

-- Ensure file ends with newline
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        local last_line = vim.api.nvim_buf_get_lines(0, -2, -1, false)[1]
        if last_line ~= "" then
            vim.api.nvim_buf_set_lines(0, -1, -1, false, { "" })
        end
    end,
})

