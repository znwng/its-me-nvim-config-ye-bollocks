return {
    "vague2k/vague.nvim",
    lazy = false,
    priority = 1000,

    config = function()
        vim.opt.termguicolors = true

        require("vague").setup({
            transparent = false,
        })

        vim.cmd("colorscheme vague")

        local function color(group, field)
            local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
            return hl[field]
        end

        local function apply_ui()
            vim.api.nvim_set_hl(0, "StatusLinePath", { fg = color("Normal", "fg") })
            vim.api.nvim_set_hl(0, "StatusLineBranch", { fg = color("Identifier", "fg") })
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = color("Number", "fg") })
            vim.api.nvim_set_hl(0, "StatusLineCur", { fg = color("CursorLineNr", "fg") })
            vim.api.nvim_set_hl(0, "StatusLineLines", { fg = color("Comment", "fg") })
            vim.api.nvim_set_hl(0, "StatusLineError", { fg = color("DiagnosticError", "fg") })
            vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = color("DiagnosticWarn", "fg") })
            vim.api.nvim_set_hl(0, "StatusLineHint", { fg = color("DiagnosticHint", "fg") })

            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true })

            vim.api.nvim_set_hl(0, "Cursor", {
                fg = color("Normal", "bg"),
                bg = color("CursorLineNr", "fg"),
            })
        end

        apply_ui()

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = apply_ui,
        })
    end,
}
