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
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),

                window = {
                    completion = cmp.config.window.bordered({
                        border = "single",
                    }),
                    documentation = cmp.config.window.bordered({
                        border = "single",
                    }),
                },

                formatting = {
                    fields = { "abbr", "kind" },
                    format = function(_, vim_item)
                        local icon = lspkind.symbolic(vim_item.kind, { mode = "symbol" }) or ""
                        vim_item.kind = string.format("%s %s", icon, vim_item.kind or "")
                        vim_item.menu = ""
                        return vim_item
                    end,
                },
            })

            -- Autopairs integration
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            require("nvim-autopairs").setup({})
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            -- === Rose Pine Moon palette ===
            local bg = "NONE" -- transparent
            local fg = "#e0def4" -- text
            local muted = "#6e6a86" -- muted
            local surface = "#393552" -- surface
            local accent = "#9ccfd8" -- foam

            -- === Apply Rose Pine highlights ===
            vim.api.nvim_set_hl(0, "CmpPmenu", { bg = bg, fg = fg })
            vim.api.nvim_set_hl(0, "CmpPmenuSel", { bg = surface, fg = accent, bold = true })
            vim.api.nvim_set_hl(0, "CmpBorder", { fg = muted, bg = bg })
            vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = muted, bg = bg })

            -- Fallbacks
            vim.api.nvim_set_hl(0, "Pmenu", { bg = bg, fg = fg })
            vim.api.nvim_set_hl(0, "PmenuSel", { bg = surface, fg = accent })
        end,
    },
}

