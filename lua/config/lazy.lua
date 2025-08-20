--[[
lazy.lua
Plugin manager bootstrap + setup
(No keymaps or general settings here)
]]

-- Path where lazy.nvim will be installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if missing
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

-- Prepend lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Set leader keys before plugins load
vim.g.mapleader = " "       -- Space as leader
vim.g.maplocalleader = "\\" -- Backslash as local leader

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { import = "plugins" },                   -- load plugins/ directory
    },
    install = { colorscheme = {} },               -- don’t force colorscheme; handle in plugins/colors.lua
    checker = { enabled = true, notify = false }, -- background update checks
    change_detection = { notify = true },         -- notify if config changes
    ui = { border = "rounded" },
})

