return {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },

    config = function()
        vim.opt.termguicolors = true

        -- Optional configuration
        require("bluloco").setup({
            style = "dark", -- "dark" | "light"
            transparent = true,
            italics = false,
            terminal = vim.fn.has("gui_running") == 1,
        })

        vim.cmd("colorscheme bluloco")

        -- KEEP your original UI exactly unchanged
        local function apply_ui()
            -- local bg = "#282828"
            local ebg = "#121212"

            vim.api.nvim_set_hl(0, "Normal", { bg = ebg })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = ebg })

            vim.api.nvim_set_hl(0, "StatusLine", { bg = "#282933" })

            vim.api.nvim_set_hl(0, "StatusLinePath", { fg = "#abb2bf", bg = "#282933" })
            vim.api.nvim_set_hl(0, "StatusLineBranch", { fg = "#4a5a73", bg = "#282933" })
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = "#eebc40", bg = "#282933" })

            vim.api.nvim_set_hl(0, "StatusLineCur", { fg = "#abb2bf", bg = "#282933" })
            vim.api.nvim_set_hl(0, "StatusLineLines", { fg = "#abb2bf", bg = "#282933" })

            vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#ff6480", bg = "#282933" })
            vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#eebc40", bg = "#282933" })
            vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#3FC56B", bg = "#282933" })
            vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#10B1FE", bg = "#282933" })

            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true })

            -- vim.api.nvim_set_hl(0, "SignColumn", { bg = "#282933" })
            -- vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#282933" })
            -- vim.api.nvim_set_hl(0, "LineNr", { bg = "#282933", fg = "#adadad" })

            vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#ffffff" })
        end

        apply_ui()

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = apply_ui,
        })
    end,
}

