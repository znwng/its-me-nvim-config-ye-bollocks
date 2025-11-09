-- lua/lazy.lua (cleaned)

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

-- Setup lazy
require("lazy").setup({
  spec = { { import = "plugins" } },
  check = { notif = false },
  checker = { enabled = true, notify = false },
  change_detection = { notify = true },
  ui = {
    border = "rounded",
    winblend = 0,
        size = {height = 0.85, width = 0.85}
  },
})

-- When Lazy finishes loading, apply a few UI tweaks safely
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Floating borders / hl (safe defaults)
    local border_color = "#fabd2f"
    local ok, _ = pcall(vim.api.nvim_set_hl, 0, "FloatBorder", { fg = border_color })
    pcall(vim.api.nvim_set_hl, 0, "NormalFloat", { bg = "NONE" })
    -- setup mason/telescope if available (pcall)
    pcall(function()
      local mason = require("mason")
      mason.setup({ ui = { border = "rounded" } })
    end)
  end,
})

