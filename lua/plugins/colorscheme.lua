--[[
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
]]

return {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    priority = 1000,
    lazy = false,

    config = function()
        vim.opt.termguicolors = true

        require("gruvbox").setup({
            transparent_mode = true,
            bold = false,
            italic = {
                strings = false,
                comments = false,
                operators = false,
                folds = false,
            },
        })

        vim.cmd("colorscheme gruvbox")

        -- KEEP your original UI exactly unchanged
        local function apply_ui()
            local bg = "#282828"
            local ebg = "#141414"

            vim.api.nvim_set_hl(0, "Normal", { bg = ebg })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = ebg })

            vim.api.nvim_set_hl(0, "StatusLine", { bg = bg })

            vim.api.nvim_set_hl(0, "StatusLinePath", { fg = "#ebdbb2", bg = "#3c3836" })
            vim.api.nvim_set_hl(0, "StatusLineBranch", { fg = "#83a598", bg = "#3c3836" })
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#fabd2f", bg = "#3c3836" })

            vim.api.nvim_set_hl(0, "StatusLineCur", { fg = "#928374", bg = "#3c3836" })
            vim.api.nvim_set_hl(0, "StatusLineLines", { fg = "#928374", bg = "#3c3836" })

            vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#fb4934", bg = "#3c3836" })
            vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#fabd2f", bg = "#3c3836" })
            vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#b8bb26", bg = "#3c3836" })
            vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#83a598", bg = "#3c3836" })

            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true })

            vim.api.nvim_set_hl(0, "SignColumn", { bg = bg })
            vim.api.nvim_set_hl(0, "LineNr", { bg = bg, fg = "#928374" })
        end

        apply_ui()

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = apply_ui,
        })
    end,
}

