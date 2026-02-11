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

vim.g.maplocalleader = "\\"

require("lazy").setup({
    spec = { { import = "plugins" } },
    check = { notif = false },
    checker = { enabled = true, notify = false },
    change_detection = { notify = true },
    ui = {
        border = "none",
        winblend = 0,
        size = { height = 0.85, width = 0.85 },
    },
})

-- Apply global UI tweaks after Lazy loads
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        -- === Vague-style palette ===
        local bg = "NONE" -- transparent
        local fg = "#d0d0d0" -- primary text
        local muted = "#5a5a5a" -- borders / separators
        local surface = "#2a2a2a" -- subtle background
        local accent = "#61ffe8" -- focus / selection

        -- Floating windows
        pcall(vim.api.nvim_set_hl, 0, "NormalFloat", { bg = bg, fg = fg })
        pcall(vim.api.nvim_set_hl, 0, "FloatBorder", { fg = muted, bg = bg })

        -- Global UI accents
        pcall(function()
            vim.api.nvim_set_hl(0, "Pmenu", { bg = bg, fg = fg })
            vim.api.nvim_set_hl(0, "PmenuSel", { bg = surface, fg = fg, bold = true })
            vim.api.nvim_set_hl(0, "CursorLine", { bg = surface })
            vim.api.nvim_set_hl(0, "VertSplit", { fg = muted, bg = bg })
            vim.api.nvim_set_hl(0, "StatusLine", { bg = surface, fg = fg })
            vim.api.nvim_set_hl(0, "StatusLineNC", { bg = surface, fg = muted })
        end)

        -- Mason UI (inherits palette cleanly)
        pcall(function()
            local mason = require("mason")
            mason.setup({
                ui = { border = "none" },
            })
        end)
    end,
})

