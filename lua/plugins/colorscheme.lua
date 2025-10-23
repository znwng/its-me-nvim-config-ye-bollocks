return {
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		config = function()
			-- Theme setup
			require("kanagawa").setup({
				compile = false,
				undercurl = true,
				commentStyle = { italic = true },
				functionStyle = { bold = true },
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = { italic = true },
				transparent = true, -- transparent main background
				dimInactive = true, -- dim inactive windows
				terminalColors = true,
				theme = "wave", -- "wave", "dragon", "lotus"
				background = { dark = "wave", light = "lotus" },
			})

			-- Apply theme safely
			vim.cmd.colorscheme("kanagawa")

			-- Custom highlights
			local function set_custom_highlights()
				local colors = require("kanagawa.colors").setup().palette
				local theme = require("kanagawa.colors").setup().theme

				-- Make only the gutter transparent (line numbers, signs, folds, GitSigns)
				local transparent_gutter = {
					"SignColumn",
					"LineNr",
					"CursorLineNr",
					"FoldColumn",
					"GitSignsAdd",
					"GitSignsChange",
					"GitSignsDelete",
				}
				for _, group in ipairs(transparent_gutter) do
					local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
					if ok then
						vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, { bg = "none", ctermbg = "none" }))
					else
						vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
					end
				end

				-- Keep statusline styled (not transparent)
				local custom = {
					StatusLine = { bg = theme.ui.bg_m3, fg = theme.ui.fg },
					StatusLineNC = { bg = theme.ui.bg_m3, fg = theme.ui.nontext },
					StatusLineError = { bg = theme.ui.bg_m3, fg = colors.peachRed },
					StatusLineWarn = { bg = theme.ui.bg_m3, fg = colors.boatYellow2 },
					StatusLineHint = { bg = theme.ui.bg_m3, fg = colors.springViolet2 },
					StatusLineInfo = { bg = theme.ui.bg_m3, fg = colors.waveAqua1 },

					-- Column bar (match StatusLine background)
					ColorColumn = { bg = theme.ui.bg_m3 },
					CursorColumn = { bg = theme.ui.bg_m3 },
					VertSplit = { bg = theme.ui.bg_m3, fg = theme.ui.nontext },
					WinSeparator = { bg = theme.ui.bg_m3, fg = theme.ui.nontext },

					-- Diagnostics
					DiagnosticUnderlineError = { underline = true, sp = colors.peachRed },
					DiagnosticUnderlineWarn = { underline = true, sp = colors.boatYellow2 },
					DiagnosticUnderlineInfo = { underline = true, sp = colors.waveAqua1 },
					DiagnosticUnderlineHint = { underline = true, sp = colors.springViolet2 },

					DiagnosticVirtualTextError = { fg = colors.peachRed },
					DiagnosticVirtualTextWarn = { fg = colors.boatYellow2 },
					DiagnosticVirtualTextInfo = { fg = colors.waveAqua1 },
					DiagnosticVirtualTextHint = { fg = colors.springViolet2 },
				}

				for group, opts in pairs(custom) do
					vim.api.nvim_set_hl(0, group, opts)
				end
			end

			-- Apply now
			set_custom_highlights()

			-- Reapply when theme reloads
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "kanagawa",
				callback = set_custom_highlights,
			})
		end,
	},
}

