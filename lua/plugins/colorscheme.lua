return {
    "vague-theme/vague.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("vague").setup({})

        vim.cmd("colorscheme vague")

        local function apply_ui()
            -- Statusline diagnostics
            vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#eb6f92", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#f6c177", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#9ccfd8", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#c4a7e7", bg = "NONE", bold = true })

            -- Mode specifier (solid, loud, intentional)
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#9ccfd8", bg = "#2a2a2b", bold = false, italic = false })

            vim.api.nvim_set_hl(0, "colorColumn", { bg = "#2a2b2b" })
        end

        apply_ui()

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = apply_ui,
        })
    end,
}

