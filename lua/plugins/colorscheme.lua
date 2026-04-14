return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
        vim.opt.termguicolors = true

        require("rose-pine").setup({
            variant = "moon", -- main change
            dark_variant = "moon",
            disable_background = true, -- matches your transparent = true intent
            disable_float_background = true,
            styles = {
                bold = false,
            },
        })

        vim.cmd("colorscheme rose-pine")

        -- KEEP your original UI exactly unchanged
        local function apply_ui()
            vim.api.nvim_set_hl(0, "StatusLine", { bg = "#101010" })
            vim.api.nvim_set_hl(0, "StatusLinePath", { fg = "#c7c7c7", bg = "#101010" })
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#6e94b2", bg = "#101010" })
            vim.api.nvim_set_hl(0, "StatusLineBranch", { fg = "#c7c7c7", bg = "#101010" })
            vim.api.nvim_set_hl(0, "StatusLineCur", { fg = "#808080", bg = "#101010" })
            vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#d74545", bg = "#101010" })
            vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#ffaf00", bg = "#101010" })
            vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#a08070", bg = "#101010" })
            vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#5f9ecf", bg = "#101010" })

            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true })

            vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#101010" })
        end

        apply_ui()

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = apply_ui,
        })
    end,
}

