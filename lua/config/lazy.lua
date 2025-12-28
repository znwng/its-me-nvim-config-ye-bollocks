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
    local bg = "NONE"
    local accent = "#88C0D0" -- soft cyan (Hubbamax accent)
    local border = "#4C566A" -- subtle gray-blue

    -- Transparent floating windows
    pcall(vim.api.nvim_set_hl, 0, "NormalFloat", { bg = bg })
    pcall(vim.api.nvim_set_hl, 0, "FloatBorder", { fg = border })

    -- Lazy/NvimTree/Telescope UI accents
    pcall(function()
      vim.api.nvim_set_hl(0, "Pmenu", { bg = bg, fg = "#ECEFF4" })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2E2E2E", fg = accent })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2E2E2E" })
      vim.api.nvim_set_hl(0, "VertSplit", { fg = border, bg = bg })
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "#282828", fg = "#92969e" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#282828", fg = "#A3BE8C" })
    end)

    -- Mason UI if available
    pcall(function()
      local mason = require("mason")
      mason.setup({ ui = { border = "rounded" } })
    end)
  end,
})

