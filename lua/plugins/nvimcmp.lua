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

            -- Load VSCode-style snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            -- =====================
            -- nvim-cmp setup
            -- =====================
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

                -- Explicitly borderless floating windows
                window = {
                    completion = {
                        border = "none",
                    },
                    documentation = {
                        border = "none",
                    },
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

            -- =====================
            -- Cmdline completion
            -- =====================
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "path" },
                    { name = "cmdline" },
                },
                completion = { autocomplete = false }, -- <-- disable auto-popup
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- =====================
            -- Autopairs integration
            -- =====================
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            require("nvim-autopairs").setup({})
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            -- =====================
            -- Solid background (borderless)
            -- =====================
            local bg = "#1f1d2e"
            local fg = "#e0def4"
            local surface = "#393552"

            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    vim.api.nvim_set_hl(0, "Pmenu", {
                        bg = bg,
                        fg = fg,
                    })

                    vim.api.nvim_set_hl(0, "PmenuSel", {
                        bg = surface,
                        fg = fg,
                        bold = true,
                    })

                    vim.api.nvim_set_hl(0, "NormalFloat", {
                        bg = bg,
                        fg = fg,
                    })
                end,
            })

            -- Apply immediately
            vim.cmd("doautocmd ColorScheme")
        end,
    },
}

