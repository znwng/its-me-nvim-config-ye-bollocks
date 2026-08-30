return {
    "metalelf0/black-metal-theme-neovim",
    lazy = false,
    priority = 1000,

    config = function()
        vim.opt.termguicolors = true

        require("black-metal").setup({
            theme = "dark-funeral",

            variant = "dark",
            alt_bg = false,
            transparent = false,

            trve = false,

            term_colors = false,

            diagnostics = {
                darker = true,
                undercurl = true,
                background = true,
            },

            code_style = {
                comments = "none",
                conditionals = "none",
                functions = "none",
                keywords = "none",
                headings = "bold",
                operators = "none",
                keyword_return = "none",
                strings = "none",
                variables = "none",
            },

            plugin = {
                lualine = {
                    bold = true,
                    plain = false,
                },

                cmp = {
                    plain = false,
                    reverse = false,
                },
            },
        })

        require("black-metal").load()

        local function color(group, field)
            local hl = vim.api.nvim_get_hl(0, {
                name = group,
                link = false,
            })

            return hl[field]
        end

        local function apply_ui()
            vim.api.nvim_set_hl(0, "StatusLinePath", {
                fg = color("Normal", "fg"),
            })

            vim.api.nvim_set_hl(0, "StatusLineBranch", {
                fg = color("String", "fg"),
            })

            vim.api.nvim_set_hl(0, "StatusLineMode", {
                fg = color("String", "fg"),
            })

            vim.api.nvim_set_hl(0, "StatusLineCur", {
                fg = color("String", "fg"),
            })

            vim.api.nvim_set_hl(0, "StatusLineLines", {
                fg = color("Comment", "fg"),
            })

            vim.api.nvim_set_hl(0, "StatusLineError", {
                fg = color("Normal", "fg"),
            })

            vim.api.nvim_set_hl(0, "StatusLineWarn", {
                fg = color("Normal", "fg"),
            })

            vim.api.nvim_set_hl(0, "StatusLineHint", {
                fg = color("Normal", "fg"),
            })

            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
                underline = true,
            })

            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
                underline = true,
            })

            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {
                underline = true,
            })

            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {
                underline = true,
            })

            vim.api.nvim_set_hl(0, "ColorColumn", {
                bg = color("CursorLine", "bg"),
            })

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
