local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if vim.loop.fs_stat(lazypath) == nil then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    repo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln("Could not install lazy.nvim: " .. tostring(out))
  end
end

vim.opt.rtp:prepend(lazypath)

-- Leader keys (set once)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = { { import = "plugins" } },
  check = { notif = false },
  checker = { enabled = true, notify = false },
  change_detection = { notify = true },
  ui = {
    border = "rounded",
    winblend = 0,
    size = { height = 0.85, width = 0.85 },
  },
})

-- Apply global UI tweaks safely after Lazy loads
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local cp = require("catppuccin.palettes").get_palette()
    local bg = "NONE" -- transparent background
    local accent = cp.sky -- Catppuccin mocha cyan accent
    local border = cp.surface0
    local selection = cp.base

    -- Transparent floating windows
    pcall(vim.api.nvim_set_hl, 0, "NormalFloat", { bg = bg })
    pcall(vim.api.nvim_set_hl, 0, "FloatBorder", { fg = border })

    -- Lazy/NvimTree/Telescope UI accents
    pcall(function()
      vim.api.nvim_set_hl(0, "Pmenu", { bg = bg, fg = cp.text })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = selection, fg = accent })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = selection })
      vim.api.nvim_set_hl(0, "VertSplit", { fg = border, bg = bg })
      vim.api.nvim_set_hl(0, "StatusLine", { bg = cp.base, fg = cp.overlay0 })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = cp.base, fg = cp.surface2 })
    end)

    -- Mason UI if available
    pcall(function()
      local mason = require("mason")
      mason.setup({ ui = { border = "rounded" } })
    end)
  end,
})

