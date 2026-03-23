return {
    "wtfox/jellybeans.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd("colorscheme jellybeans")
        local function apply_ui()
            vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#d74545", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#ffaf00", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#a08070", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#5f9ecf", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, sp = "#d74545" })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "#ffaf00" })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, sp = "#a08070" })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "#5f9ecf" })
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#9ccfd8", bg = "#2a2a2b" })
            vim.api.nvim_set_hl(0, "colorColumn", { bg = "#2a2b2b" })
            vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2a2a2b" })
            vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#2a2b2b" })
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#9ccfd8", bg = "#2a2a2b" })
            vim.api.nvim_set_hl(0, "IblIndent", { fg = "#252525", nocombine = true })
        end
        apply_ui()
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = apply_ui,
        })
    end,
}

