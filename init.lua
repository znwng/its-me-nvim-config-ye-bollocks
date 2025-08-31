vim.o.mouse = "a"                                          -- Enable mouse support
vim.opt.termguicolors = true                               -- Enable true color support in terminal
vim.opt.updatetime = 250                                   -- Faster update time (used for CursorHold, etc.)
vim.opt.colorcolumn = "100"                                -- Show vertical line at column 100
vim.opt.breakindent = true                                 -- Enable break indent (keeps indent on wrapped lines)
vim.opt.signcolumn = "yes"                                 -- Always show sign column (used for git, diagnostics, etc.)
vim.opt.number = true                                      -- Show absolute line numbers
vim.opt.relativenumber = true                              -- Show relative line numbers
vim.opt.scrolloff = 10                                     -- Keep 10 lines visible above/below cursor when scrolling
vim.opt.expandtab = false                                  -- Use hard tabs instead of spaces
vim.opt.tabstop = 4                                        -- Tab width is 4 spaces
vim.opt.shiftwidth = 4                                     -- Indent size is 4 spaces
vim.opt.smartindent = true                                 -- Smarter auto-indentation
vim.opt.autoindent = true                                  -- Enable automatic indentation
vim.opt.incsearch = true                                   -- Highlight search results as you type
vim.opt.ignorecase = true                                  -- Ignore case in searches...
vim.opt.smartcase = true                                   -- ...unless search contains uppercase letters
vim.opt.hlsearch = true                                    -- Highlight all search matches
vim.opt.swapfile = false                                   -- Disable swap files
vim.opt.backup = false                                     -- Disable backup files
vim.opt.undofile = true                                    -- Enable persistent undo
vim.opt.undodir = { os.getenv("HOME") .. "/.vim/undodir" } -- Directory to save undo history

-- Function: count diagnostics by severity
function _G.diag_count(severity)
    local sev = vim.diagnostic.severity[severity:upper()]
    local diags = vim.diagnostic.get(0, { severity = sev })
    return #diags
end

-- Function: human-readable file size for statusline
function _G.human_file_size()
    local file = vim.fn.expand("%:p")
    if file == "" or vim.fn.filereadable(file) == 0 then
        return "~"
    end
    local size = vim.fn.getfsize(file)
    if size < 0 then return "~" end
    if size < 1024 then
        return size .. "B"
    elseif size < 1024 * 1024 then
        return string.format("%.1fKB", size / 1024)
    elseif size < 1024 * 1024 * 1024 then
        return string.format("%.1fMB", size / (1024 * 1024))
    else
        return string.format("%.1fGB", size / (1024 * 1024 * 1024))
    end
end

-- Custom statusline
vim.o.statusline = table.concat({
    "%{expand('%:p')} %m %=",                            -- File path + modified flag
    "%#StatusLineError#E:%{v:lua.diag_count('Error')} ", -- Error count
    "%#StatusLineWarn#W:%{v:lua.diag_count('Warn')} ",   -- Warning count
    "%#StatusLineHint#H:%{v:lua.diag_count('Hint')} ",   -- Hint count
    "%#StatusLineInfo#I:%{v:lua.diag_count('Info')} ",   -- Info count
    "%#StatusLine#[%{v:lua.human_file_size()}] ",        -- File size
    "%#StatusLine#[%l:%c]",                              -- Line:Column
})

-- Load plugin manager (lazy.nvim)
require("config.lazy")

-- Autocommands --

-- Make popups/menus transparent on colorscheme change
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

-- Restore cursor to last position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Auto-format file before saving (if LSP supports it)
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        if vim.lsp.buf.format then
            pcall(vim.lsp.buf.format, { async = false })
        end
    end,
})

-- Ensure file ends with a newline
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        local last_line = vim.api.nvim_buf_get_lines(0, -2, -1, false)[1]
        if last_line ~= "" then
            vim.api.nvim_buf_set_lines(0, -1, -1, false, { "" })
        end
    end,
})

