return {
    "vague-theme/vague.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("vague").setup({
            -- colors = {
            --     func = "#bc96b0",
            --     keyword = "#787bab",
            --     string = "#8a739a",
            --     number = "#8f729e",
            -- },
        })

        vim.cmd("colorscheme vague")

        local function apply_ui()
            vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#eb6f92", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#f6c177", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#9ccfd8", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#c4a7e7", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, sp = "#eb6f92" })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "#f6c177" })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "#9ccfd8" })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, sp = "#c4a7e7" })
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#9ccfd8", bg = "#2a2a2b", bold = false, italic = false })
            vim.api.nvim_set_hl(0, "colorColumn", { bg = "#2a2b2b" })

            -- Transparent background only for main editor
            vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE" })

            -- Keep floating windows normal
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2a2a2b" }) -- or your theme's default float bg
            vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#2a2b2b" })
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#9ccfd8", bg = "#2a2a2b", bold = false, italic = false })

            vim.api.nvim_set_hl(0, "IblIndent", {
                fg = "#252525",
                nocombine = true,
            })
        end

        apply_ui()

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = apply_ui,
        })
    end,
}

