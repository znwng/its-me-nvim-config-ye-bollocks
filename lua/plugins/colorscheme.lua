return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                variant = "moon",
                dark_variant = "moon",
                transparent_background = true,
                integrations = {
                    lualine = false,
                    treesitter = true,
                    telescope = true,
                },
            })

            vim.cmd("colorscheme rose-pine")

            -- Palette
            local fg = "#e0def4"
            local muted = "#6e6a86"
            local status_bg = "#121212"

            local transparent_groups = {
                "Normal",
                "NormalNC",
                "NormalFloat",
                "SignColumn",
                "EndOfBuffer",
                "MsgArea",
            }

            local function apply_ui()
                -- Core transparency
                for _, group in ipairs(transparent_groups) do
                    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
                end

                -- Statusline (SOLID background)
                vim.api.nvim_set_hl(0, "StatusLine", {
                    bg = status_bg,
                    fg = fg,
                })

                vim.api.nvim_set_hl(0, "StatusLineNC", {
                    bg = status_bg,
                    fg = muted,
                })

                -- Diagnostics in statusline
                vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#eb6f92", bg = "NONE", bold = true })
                vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#f6c177", bg = "NONE", bold = true })
                vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#9ccfd8", bg = "NONE", bold = true })
                vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#c4a7e7", bg = "NONE", bold = true })

                -- Color column intentionally solid
                vim.api.nvim_set_hl(0, "ColorColumn", { bg = status_bg })

                vim.api.nvim_set_hl(0, "StatusLineMode", { bg = "#61ffe8", fg = "#292929", bold = true, italic = true })

                -- Comments
                vim.api.nvim_set_hl(0, "Comment", { fg = muted, italic = true })
            end

            -- Apply once now
            apply_ui()

            -- Re-apply on any colorscheme reload
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = apply_ui,
            })
        end,
    },
}

