return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			-- Theme setup
			require("rose-pine").setup({
				variant = "moon", -- "main", "moon", "dawn"
				bold_vert_split = false,
				dim_nc_background = true,
				disable_background = true,
				disable_float_background = false,
				disable_italics = false,
				disable_bold = false,
			})

			-- Apply theme safely
			vim.cmd.colorscheme("rose-pine")

			-- Custom highlights
			local function set_custom_highlights()
				local colors = {
					bg = "#303131",
					fg = "#e0def4",
					inactive_fg = "#6e6a86",
					error = "#eb6f92",
					warn = "#f6c177",
					hint = "#f5c2e7",
					info = "#9ccfd8",
				}

				-- Statusline
				local statusline_hl = {
					StatusLine = { bg = colors.bg, fg = colors.fg },
					StatusLineNC = { bg = colors.bg, fg = colors.inactive_fg },
					StatusLineError = { bg = colors.bg, fg = colors.error },
					StatusLineWarn = { bg = colors.bg, fg = colors.warn },
					StatusLineHint = { bg = colors.bg, fg = colors.hint },
					StatusLineInfo = { bg = colors.bg, fg = colors.info },
					ColorColumn = { bg = colors.bg },
				}

				-- Diagnostics
				local diagnostic_hl = {
					DiagnosticUnderlineError = { underline = true, fg = colors.error },
					DiagnosticUnderlineWarn = { underline = true, fg = colors.warn },
					DiagnosticUnderlineInfo = { underline = true, fg = colors.info },
					DiagnosticUnderlineHint = { underline = true, fg = colors.hint },

					DiagnosticVirtualTextError = { fg = colors.error },
					DiagnosticVirtualTextWarn = { fg = colors.warn },
					DiagnosticVirtualTextInfo = { fg = colors.info },
					DiagnosticVirtualTextHint = { fg = colors.hint },
				}

				-- Apply all highlights
				for group, opts in pairs(vim.tbl_extend("force", statusline_hl, diagnostic_hl)) do
					vim.api.nvim_set_hl(0, group, opts)
				end
			end

			-- Apply now
			set_custom_highlights()

			-- Reapply when theme reloads
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "rose-pine",
				callback = set_custom_highlights,
			})
		end,
	},
}

