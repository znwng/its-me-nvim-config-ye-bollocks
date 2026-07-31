return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,

    config = function()
        vim.opt.termguicolors = true

        require("tokyonight").setup({
            style = "night", -- storm | moon | night | day
            transparent = false,
            terminal_colors = true,
            styles = {
                comments = { italic = false },
                keywords = { italic = false },
                sidebars = "transparent",
                floats = "transparent",
            },
        })

        vim.cmd("colorscheme tokyonight")

        -- KEEP your original UI exactly unchanged
        local function apply_ui()
            local ebg = "#121212"
            -- local sbg = "#282933"
            local sbg = "#322f3b"

            -- vim.api.nvim_set_hl(0, "Normal", { fg = "#c0caf5", bg = ebg })
            -- vim.api.nvim_set_hl(0, "NormalNC", { fg = "#a9b1d6", bg = ebg })

            vim.api.nvim_set_hl(0, "StatusLine", { bg = sbg })

            vim.api.nvim_set_hl(0, "StatusLinePath", { fg = "#c0caf5", bg = sbg })
            vim.api.nvim_set_hl(0, "StatusLineBranch", { fg = "#7aa2f7", bg = sbg })
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#e0af68", bg = sbg })

            vim.api.nvim_set_hl(0, "StatusLineCur", { fg = "#c0caf5", bg = sbg })
            vim.api.nvim_set_hl(0, "StatusLineLines", { fg = "#a9b1d6", bg = sbg })

            vim.api.nvim_set_hl(0, "LineNr", { fg = "#4f4a78" })

            vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#f7768e", bg = sbg })
            vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#e0af68", bg = sbg })
            vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#7dcfff", bg = sbg })
            vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#73daca", bg = sbg })

            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true })

            vim.api.nvim_set_hl(0, "Cursor", { fg = "#1a1b26", bg = "#c0caf5" })
            -- vim.api.nvim_set_hl(0, "ColorColumn", { bg = sbg })
        end

        apply_ui()

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = apply_ui,
        })
    end,
}

