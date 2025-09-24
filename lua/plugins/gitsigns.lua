--[[
Keybinds for gitsigns.nvim:

Hunk actions:
<leader>hs  -> Stage current hunk
<leader>hr  -> Reset current hunk
<leader>hS  -> Stage entire buffer
<leader>hR  -> Reset entire buffer

Preview:
<leader>hp  -> Preview current hunk
<leader>hi  -> Preview current hunk inline

Blame & diff:
<leader>hb  -> Git blame (full info) for current line
<leader>hd  -> Show Git diff (against index)
<leader>hD  -> Show Git diff (against last commit, HEAD~)

Quickfix:
<leader>hQ  -> Add all hunks to quickfix list
<leader>hq  -> Add current file's hunks to quickfix list

Toggles:
<leader>tb  -> Toggle inline Git blame
<leader>td  -> Toggle deleted lines
<leader>tw  -> Toggle word diffs

Navigation & text objects:
ih          -> Git hunk text object (operator & visual modes)
[c / ]c     -> Jump to previous/next hunk
]]

return {
	{
		-- Git integration for diffing, staging, blame, and hunks
		"lewis6991/gitsigns.nvim",

		config = function()
			-- Ensure leader key is set
			vim.g.mapleader = " "

			require("gitsigns").setup({
				attach_to_untracked = false, -- Skip untracked files
				current_line_blame = false, -- Show inline blame by default
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 250, -- Delay before showing blame (ms)
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

				on_attach = function(bufnr)
					local gs = require("gitsigns")

					-- Helper to set buffer-local keymaps
					local function map(mode, lhs, rhs, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, lhs, rhs, opts)
					end

					-- Navigate between hunks
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

					-- Preview hunks
					map("n", "<leader>hp", gs.preview_hunk)
					map("n", "<leader>hi", gs.preview_hunk_inline)

					-- Blame & diff
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end)
					map("n", "<leader>hd", gs.diffthis)
					map("n", "<leader>hD", function()
						gs.diffthis("HEAD~")
					end)

					-- Add hunks to quickfix list
					map("n", "<leader>hQ", function()
						gs.setqflist("all")
					end)
					map("n", "<leader>hq", gs.setqflist)

					-- Toggle options
					map("n", "<leader>tb", gs.toggle_current_line_blame)
					map("n", "<leader>td", gs.toggle_deleted)
					map("n", "<leader>tw", gs.toggle_word_diff)

					-- Text object for Git hunk
					map({ "o", "x" }, "ih", gs.select_hunk)
				end,
			})
		end,
	},
}

