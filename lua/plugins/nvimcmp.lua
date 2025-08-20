--[[
Keybindings for nvim-cmp:

<C-Space> -> Trigger completion menu
<CR>      -> Confirm completion selection
<Tab>     -> Next item / expand/jump snippet
<S-Tab>   -> Previous item / jump backwards in snippet
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

            -- Load VS Code-style snippets
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

                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text", -- show symbol + text
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },

                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })

            -- Autopairs integration with cmp confirm
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            require("nvim-autopairs").setup({})
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            -- Highlight groups for transparency + borders
            vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#7d5dff", bg = "NONE", blend = 15 })
            vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = "#7d5dff", bg = "NONE", blend = 15 })
            vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", blend = 15 })
            vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#313244", blend = 0 })
        end,
    },
}

