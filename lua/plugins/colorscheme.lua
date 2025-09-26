return {
	{
		-- Rose Pine theme
		"rose-pine/neovim",
		name = "rose-pine",

		config = function()
			-- Theme options
			require("rose-pine").setup({
				variant = "moon", -- "main", "moon", or "dawn"
				bold_vert_split = false, -- No bold vertical split lines
				dim_nc_background = true, -- Dim background of inactive windows
				disable_background = true, -- Transparent main background
				disable_float_background = false, -- Keep background for floating windows
				disable_italics = true, -- No italics in UI
				disable_bold = true, -- No bolds
			})

			-- Apply theme
			vim.cmd("colorscheme rose-pine")

			-- Custom highlights (statusline + diagnostics)
			local function set_statusline_hl()
				-- Statusline (active/inactive + diagnostic levels)
				vim.api.nvim_set_hl(0, "StatusLine", { bg = "#363636", fg = "#e0def4" })
				vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#363636", fg = "#6e6a86" })
				vim.api.nvim_set_hl(0, "StatusLineError", { bg = "#363636", fg = "#eb6f92" })
				vim.api.nvim_set_hl(0, "StatusLineWarn", { bg = "#363636", fg = "#f6c177" })
				vim.api.nvim_set_hl(0, "StatusLineHint", { bg = "#363636", fg = "#f5c2e7" })
				vim.api.nvim_set_hl(0, "StatusLineInfo", { bg = "#363636", fg = "#9ccfd8" })
				vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#363636" })

				-- Underlines for diagnostics
				vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, fg = "#eb6f92" })
				vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, fg = "#f6c177" })
				vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, fg = "#9ccfd8" })
				vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, fg = "#f5c2e7" })

				-- Diagnostic virtual text
				vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#eb6f92" })
				vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#f6c177" })
				vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#9ccfd8" })
				vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#f5c2e7" })
			end

			-- Apply highlights now
			set_statusline_hl()

			-- Re-apply highlights if theme reloads
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "rose-pine",
				callback = set_statusline_hl,
			})
		end,
	},
}

