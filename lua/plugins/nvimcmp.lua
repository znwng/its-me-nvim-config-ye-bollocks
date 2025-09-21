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
		-- Main completion engine
		"hrsh7th/nvim-cmp",

		-- Extra sources + snippet + UI helpers
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP suggestions
			"hrsh7th/cmp-buffer", -- Words from current buffer
			"hrsh7th/cmp-path", -- File paths
			"hrsh7th/cmp-cmdline", -- Command-line completion
			"saadparwaiz1/cmp_luasnip", -- Snippets source
			"L3MON4D3/LuaSnip", -- Snippet engine
			"rafamadriz/friendly-snippets", -- Ready-to-use snippets
			"onsails/lspkind.nvim", -- Icons in menu
			"windwp/nvim-autopairs", -- Auto-close brackets/quotes
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			-- Load predefined snippets (VS Code style)
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Setup nvim-cmp
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				-- Key mappings for completion/snippets
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

				-- Sources for suggestions (priority order)
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),

				-- Show icons + text, limit width
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
			})

			-- Autopairs: auto-insert closing bracket/quote after confirming
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			require("nvim-autopairs").setup({})
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			-- Styling: transparent menu with purple borders
			vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#7d5dff", bg = "NONE", blend = 15 })
			vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = "#7d5dff", bg = "NONE", blend = 15 })
			vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", blend = 15 })
			vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#313244", blend = 0 })
		end,
	},
}

