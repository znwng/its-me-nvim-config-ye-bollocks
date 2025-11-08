-- General editor settings
vim.o.mouse = "a"
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.colorcolumn = "80"
vim.opt.breakindent = true
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10

-- Tabs (you prefer tabs over spaces)
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search behavior
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir

-- Count diagnostics by severity (safe)
local function diag_count(sev_name)
  local sev = vim.diagnostic.severity[sev_name:upper()]
  if not sev then return 0 end
  local diags = vim.diagnostic.get(0, { severity = sev })
  return #diags
end

-- Return human readable file size or "~" for unknown
local function human_file_size()
  local file = vim.fn.expand("%:p")
  if file == "" or vim.fn.filereadable(file) == 0 then
    return "~"
  end
  local size = vim.fn.getfsize(file)
  if size < 0 then return "~" end
  if size < 1024 then return tostring(size) .. "B" end
  if size < 1024 * 1024 then return string.format("%.1fKB", size / 1024) end
  if size < 1024 * 1024 * 1024 then return string.format("%.1fMB", size / (1024 * 1024)) end
  return string.format("%.1fGB", size / (1024 * 1024 * 1024))
end

-- Get git branch or "~" (safe)
local function git_branch()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" or vim.fn.isdirectory(dir) == 0 then return "~" end
  local cmd = "git -C " .. vim.fn.fnameescape(dir) .. " rev-parse --abbrev-ref HEAD 2>/dev/null"
  local branch = vim.fn.system(cmd)
  branch = vim.fn.trim(branch)
  if branch == "" then return "~" end
  return branch
end

-- Expose minimal helpers to statusline via v:lua
_G._statusline = {
  diag_count = diag_count,
  human_file_size = human_file_size,
  git_branch = git_branch,
}

-- Custom statusline
vim.o.statusline = table.concat({
  "%{expand('%:p')} ",
  "%#StatusLineBranch#[" .. "%{v:lua._statusline.git_branch()}" .. "] ",
  "%m %=",
  "%#StatusLineError# %{v:lua._statusline.diag_count('ERROR')} ",
  "%#StatusLineWarn# %{v:lua._statusline.diag_count('WARN')} ",
  "%#StatusLineHint# %{v:lua._statusline.diag_count('HINT')} ",
  "%#StatusLineInfo# %{v:lua._statusline.diag_count('INFO')} ",
  "%#StatusLine#[" .. "%{v:lua._statusline.human_file_size()}" .. "] ",
  "%#StatusLine#[%l:%c]",
})

-- Plugins
require("config.lazy") -- plugin manager bootstrap + loader

-- Autocommands
-- Make popups transparent on colorscheme change (safe)
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    for _, group in ipairs({ "CmpBorder", "CmpDocBorder", "CmpDoc", "Pmenu", "PmenuSel", "PmenuBorder" }) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = "none", blend = 0 })
  end,
})

-- MatchParen highlight (underline)
vim.api.nvim_set_hl(0, "MatchParen", { underline = true, bold = false, bg = "NONE", fg = "NONE" })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
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

-- Ensure file ends with newline on write (robust)
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local lines = vim.api.nvim_buf_get_lines(0, -2, -1, false)
    local last = (lines and lines[1]) or ""
    if last ~= "" then
      vim.api.nvim_buf_set_lines(0, -1, -1, false, { "" })
    end
  end,
})

