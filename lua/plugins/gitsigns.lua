--[[
Keybinds:
<leader>hs  -> Stage current hunk
<leader>hr  -> Reset current hunk
<leader>hS  -> Stage entire buffer
<leader>hR  -> Reset entire buffer
<leader>hp  -> Preview hunk
<leader>hi  -> Preview hunk inline
<leader>hb  -> Git blame for the current line
<leader>hd  -> Show Git diff (against index)
<leader>hD  -> Show Git diff (against last commit)
<leader>hQ  -> Add all hunks to quickfix list
<leader>hq  -> Add file's hunks to quickfix list
<leader>td  -> Toggle deleted lines
<leader>tw  -> Toggle word diffs
ih          -> Git hunk text object (for operator & visual mode)
[c / ]c     -> Navigate between hunks
]]

return {
	{
		-- Plugin: gitsigns.nvim — Git integration for showing diffs & hunks
		"lewis6991/gitsigns.nvim",

		config = function()
			vim.g.mapleader = " "

			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = require("gitsigns")

					local function map(mode, lhs, rhs, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, lhs, rhs, opts)
					end

					-- Enable inline blame by default
					gs.toggle_current_line_blame()

					-- Navigation between hunks
					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gs.nav_hunk("next")
						end
					end)
					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gs.nav_hunk("prev")
						end
					end)

					-- Stage/reset individual hunks
					map("n", "<leader>hs", gs.stage_hunk)
					map("n", "<leader>hr", gs.reset_hunk)
					map("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)

					-- Stage/reset entire buffer
					map("n", "<leader>hS", gs.stage_buffer)
					map("n", "<leader>hR", gs.reset_buffer)

					-- Preview
					map("n", "<leader>hp", gs.preview_hunk)
					map("n", "<leader>hi", gs.preview_hunk_inline)

					-- Blame & diff
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end)
					map("n", "<leader>hd", gs.diffthis)
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end)

					-- Quickfix
					map("n", "<leader>hQ", function()
						gs.setqflist("all")
					end)
					map("n", "<leader>hq", gs.setqflist)

					-- Toggles
					map("n", "<leader>td", gs.toggle_deleted)
					map("n", "<leader>tw", gs.toggle_word_diff)

					-- Text object for Git hunk
					map({ "o", "x" }, "ih", gs.select_hunk)
				end,
			})
		end,
	},
}

