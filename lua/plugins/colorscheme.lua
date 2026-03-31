return -- Using lazy.nvim
{
    "metalelf0/black-metal-theme-neovim",
    lazy = false,
    priority = 1000,
    config = function()
        require("black-metal").setup({
            -- [ bathory burzum dark-funeral darkthrone emperor gorgoroth immortal
            --  impaled-nazarene khold marduk mayhem nile taake thyrfing venom windir]
            theme = "immortal",
        })
        require("black-metal").load()

        local function apply_ui()
            vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#d74545", bg = "NONE" })
            vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#ffaf00", bg = "NONE" })
            vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#a08070", bg = "NONE" })
            vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#5f9ecf", bg = "NONE" })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true })
            vim.api.nvim_set_hl(0, "colorColumn", { bg = "#2a2b2b" })
        end
        apply_ui()
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = apply_ui,
        })
    end,
}

