--[[
nvim-cmp (Autocompletion)

Keybindings:
<C-Space> -> Open completion menu
<CR>      -> Confirm selected item
<Tab>     -> Next item / expand or jump in snippet
<S-Tab>   -> Previous item / jump back in snippet
]]

return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
            "onsails/lspkind.nvim",
            "windwp/nvim-autopairs",
        },

        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            require("luasnip.loaders.from_vscode").lazy_load()

            -- nvim-cmp setup
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                },

                window = {
                    completion = { border = "none" },
                    documentation = { border = "none" },
                },

                formatting = {
                    fields = { "abbr", "kind", "menu" },
                    format = lspkind.cmp_format({
                        mode = "symbol",
                        maxwidth = 50,
                        ellipsis_char = "…",
                        menu = {
                            nvim_lsp = "[LSP]",
                            luasnip = "[SNIP]",
                            buffer = "[BUF]",
                            path = "[PATH]",
                        },
                    }),
                },
            })

            -- Cmdline completion
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "path" },
                    { name = "cmdline" },
                },
                completion = { autocomplete = false },
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Autopairs
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            require("nvim-autopairs").setup({})
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            -- Vague-style popup colors
            local bg = "#1e1e1e" -- neutral dark
            local fg = "#d0d0d0" -- soft text
            local surface = "#2a2a2a" -- selection
            local accent = "#61ffe8" -- focus highlight

            local function apply_cmp_ui()
                vim.api.nvim_set_hl(0, "Pmenu", { bg = bg, fg = fg })
                vim.api.nvim_set_hl(0, "PmenuSel", { bg = surface, fg = fg, bold = true })
                vim.api.nvim_set_hl(0, "PmenuThumb", { bg = accent })
                vim.api.nvim_set_hl(0, "PmenuSbar", { bg = surface })
                vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg, fg = fg })
            end

            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = apply_cmp_ui,
            })

            apply_cmp_ui()
        end,
    },
}

