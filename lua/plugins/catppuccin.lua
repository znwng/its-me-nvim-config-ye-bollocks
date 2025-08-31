return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            -- Setup Catppuccin
            require("catppuccin").setup({
                flavour = "frappe",            -- latte, frappe, macchiato, mocha
                transparent_background = true, -- transparent editor background
                term_colors = true,
                styles = {
                    comments = { "italic" }, -- only comments italic
                },
                integrations = {
                    lsp_trouble = true,
                    treesitter = true,
                    native_lsp = {
                        enabled = true,
                    },
                },
            })

            -- Apply colorscheme
            vim.cmd("colorscheme catppuccin")

            -- Function to set statusline highlights
            local function set_statusline_hl()
                -- Statusline
                vim.api.nvim_set_hl(0, "StatusLine", { bg = "#1e1e2e", fg = "#cdd6f4" })
                vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#1e1e2e", fg = "#6c7086" })
                vim.api.nvim_set_hl(0, "StatusLineError", { bg = "none", fg = "#f38ba8" })
                vim.api.nvim_set_hl(0, "StatusLineWarn", { bg = "none", fg = "#f9e2af" })
                vim.api.nvim_set_hl(0, "StatusLineHint", { bg = "none", fg = "#6c7086" })
                vim.api.nvim_set_hl(0, "StatusLineInfo", { bg = "none", fg = "#89b4fa" })
                vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#313244" })

                -- Diagnostics in the buffer (text underlines)
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineError",
                    { underline = true, undercurl = false, fg = "#f38ba8" })
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, undercurl = false, fg = "#f9e2af" })
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, undercurl = false, fg = "#89b4fa" })
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, undercurl = false, fg = "#6c7086" })

                -- Optional: virtual text colors
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#f38ba8" })
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#f9e2af" })
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#89b4fa" })
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#6c7086" })
            end

            -- Set highlights now
            set_statusline_hl()

            -- Ensure highlights persist on colorscheme reload
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "catppuccin",
                callback = set_statusline_hl,
            })

            -- Configure diagnostics to use underline (straight)
            vim.diagnostic.config({
                underline = true,
                virtual_text = false,
                signs = true,
                update_in_insert = false,
                severity_sort = true,
            })
        end,
    },
}

