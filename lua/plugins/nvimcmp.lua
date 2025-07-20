--[[
Keybindings for nvim-cmp:

<C-Space> -> Trigger completion menu
<CR>      -> Confirm completion selection
<Tab>     -> Select next completion item
<S-Tab>   -> Select previous completion item
]]

return {
	{
		-- Plugin: nvim-cmp (Autocompletion framework for Neovim)
		"hrsh7th/nvim-cmp",

		-- Dependencies for additional completion sources and functionality
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP-based completion
			"hrsh7th/cmp-buffer", -- Buffer word completion
			"hrsh7th/cmp-path", -- Path completion
			"hrsh7th/cmp-cmdline", -- Command-line completion
			"saadparwaiz1/cmp_luasnip", -- Snippet support
			"L3MON4D3/LuaSnip", -- Snippet engine
			"rafamadriz/friendly-snippets", -- Predefined snippets
			"onsails/lspkind.nvim", -- Adds icons to completion items
			"windwp/nvim-autopairs", -- Auto-closing pairs
		},

		-- Plugin configuration
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- Load VS Code-style snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			-- nvim-cmp setup
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				-- Key mappings for completion navigation
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),

				-- Completion sources
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),

				-- Formatting for completion menu
				formatting = {
					format = require("lspkind").cmp_format({ with_text = true }),
				},

				-- Bordered, transparent windows with custom highlights
				window = {
					completion = {
						border = "rounded",
						winhighlight = "Normal:Pmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
					},
					documentation = {
						border = "rounded",
						winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
					},
				},
			})

			-- Auto-pair setup
			require("nvim-autopairs").setup({})

			-- Slightly translucent popups + cyan borders + proper highlight
			vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#7d5dff", bg = "NONE", blend = 15 }) -- cyan border
			vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = "#7d5dff", bg = "NONE", blend = 15 }) -- cyan doc border
			vim.api.nvim_set_hl(0, "CmpDoc", { bg = "NONE", blend = 15 })
			vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", blend = 15 })
			vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#313244", blend = 0 })
			vim.api.nvim_set_hl(0, "PmenuBorder", { fg = "#7d5dff", bg = "NONE", blend = 15 }) -- fallback border hl
		end,
	},
}
