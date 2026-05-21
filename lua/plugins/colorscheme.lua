return {
    "vague-theme/vague.nvim",
    name = "vague",
    lazy = false,
    priority = 1000,
    config = function()
        vim.opt.termguicolors = true

        require("vague").setup({
            transparent = true, -- closest equivalent to your old setup
            bold = false,
            italic = false,
        })

        vim.cmd("colorscheme vague")

        -- KEEP your original UI exactly unchanged
        local function apply_ui()
            -- local bg = "#101010"
            local bg = "#222222"
            vim.api.nvim_set_hl(0, "StatusLine", { bg = bg })
            vim.api.nvim_set_hl(0, "StatusLinePath", { fg = "#c7c7c7", bg = bg })
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#6e94b2", bg = bg })
            vim.api.nvim_set_hl(0, "StatusLineBranch", { fg = "#c7c7c7", bg = bg })
            vim.api.nvim_set_hl(0, "StatusLineCur", { fg = "#808080", bg = bg })
            vim.api.nvim_set_hl(0, "StatusLineLines", { fg = "#808080", bg = bg })
            vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#d74545", bg = bg })
            vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#ffaf00", bg = bg })
            vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#a08070", bg = bg })
            vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#5f9ecf", bg = bg })

            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true })

            vim.api.nvim_set_hl(0, "ColorColumn", { bg = bg})
        end

        apply_ui()

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = apply_ui,
        })
    end,
}

