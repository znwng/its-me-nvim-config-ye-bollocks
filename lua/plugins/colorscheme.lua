return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            -- Setup Rose Pine
            require("rose-pine").setup({
                variant = "moon",
                bold_vert_split = false,
                dim_nc_background = true,
                disable_background = true,
                disable_float_background = false,
                disable_italics = true,
            })

            -- Apply colorscheme
            vim.cmd("colorscheme rose-pine")

            -- Statusline highlights using Rose Pine Moon palette
            local function set_statusline_hl()
                vim.api.nvim_set_hl(0, "StatusLine", { bg = "#1f1d2e", fg = "#e0def4" })
                vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#1f1d2e", fg = "#6e6a86" })
                vim.api.nvim_set_hl(0, "StatusLineError", { bg = "#1f1d2e", fg = "#eb6f92" })
                vim.api.nvim_set_hl(0, "StatusLineWarn", { bg = "#1f1d2e", fg = "#f6c177" })
                vim.api.nvim_set_hl(0, "StatusLineHint", { bg = "#1f1d2e", fg = "#f5c2e7" })
                vim.api.nvim_set_hl(0, "StatusLineInfo", { bg = "#1f1d2e", fg = "#9ccfd8" })
                vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#1f1d2e" })

                -- Diagnostics underlines
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineError",
                    { underline = true, undercurl = false, fg = "#eb6f92" })
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, undercurl = false, fg = "#f6c177" })
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, undercurl = false, fg = "#9ccfd8" })
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, undercurl = false, fg = "#f5c2e7" })

                -- Virtual text colors
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#eb6f92" })
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#f6c177" })
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#9ccfd8" })
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#f5c2e7" })
            end

            -- Apply highlights
            set_statusline_hl()

            -- Persist highlights on colorscheme reload
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "rose-pine",
                callback = set_statusline_hl,
            })
        end,
    },
}

