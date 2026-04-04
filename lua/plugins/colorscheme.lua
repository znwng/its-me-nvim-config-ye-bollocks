return -- Using lazy.nvim
{
    "wtfox/jellybeans.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("jellybeans").setup({
            -- [ bathory burzum dark-funeral darkthrone emperor gorgoroth immortal
            --  impaled-nazarene khold marduk mayhem nile taake thyrfing venom windir]
            -- theme = "immortal",
            transparent = true,
        })
        require("jellybeans").load()

        local function apply_ui()
            vim.api.nvim_set_hl(0, "StatusLinePath", { fg = "#c7c7c7", bg = "#111111" })
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#808080", bg = "#111111" })
            vim.api.nvim_set_hl(0, "StatusLineBranch", { fg = "#c7c7c7", bg = "#111111" })
            vim.api.nvim_set_hl(0, "StatusLineCur", { fg = "#808080", bg = "#111111" })
            vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#d74545", bg = "#111111" })
            vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#ffaf00", bg = "#111111" })
            vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#a08070", bg = "#111111" })
            vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#5f9ecf", bg = "#111111" })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true })
            vim.api.nvim_set_hl(0, "colorColumn", { bg = "#111111" })
        end
        apply_ui()
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = apply_ui,
        })
    end,
}

