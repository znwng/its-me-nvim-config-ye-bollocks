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
                vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", fg = "#838ba7" })
                vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none", fg = "#51576d" })
                vim.api.nvim_set_hl(0, "StatusLineError", { bg = "none", fg = "#e78284" })
                vim.api.nvim_set_hl(0, "StatusLineWarn", { bg = "none", fg = "#e5c890" })
                vim.api.nvim_set_hl(0, "StatusLineHint", { bg = "none", fg = "#51576d" })
                vim.api.nvim_set_hl(0, "StatusLineInfo", { bg = "none", fg = "#89b4fa" })
                vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#1e1e2e" })

                -- Diagnostics in the buffer (text underlines)
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineError",
                    { underline = true, undercurl = false, fg = "#e78284" })
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, undercurl = false, fg = "#e5c890" })
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, undercurl = false, fg = "#89b4fa" })
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, undercurl = false, fg = "#51576d" })

                -- Optional: virtual text colors
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#e78284" })
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#e5c890" })
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#89b4fa" })
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#51576d" })
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

