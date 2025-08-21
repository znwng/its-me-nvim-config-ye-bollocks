--[[
Keybinds:
<leader>hs  -> Stage current hunk
<leader>hr  -> Reset current hunk
<leader>hS  -> Stage entire buffer
<leader>hR  -> Reset entire buffer
<leader>hp  -> Preview hunk
<leader>hi  -> Preview hunk inline
<leader>hb  -> Git blame for the current line (full info)
<leader>hd  -> Show Git diff (against index)
<leader>hD  -> Show Git diff (against last commit, HEAD~)
<leader>hQ  -> Add all hunks to quickfix list
<leader>hq  -> Add file's hunks to quickfix list
<leader>tb  -> Toggle inline Git blame
<leader>td  -> Toggle deleted lines
<leader>tw  -> Toggle word diffs
ih          -> Git hunk text object (for operator & visual mode)
[c / ]c     -> Navigate between hunks
]]

return {
    {
        -- Plugin: gitsigns.nvim — Git integration for diffing, staging, blame, and hunks
        "lewis6991/gitsigns.nvim",

        config = function()
            -- Ensure leader key is set
            vim.g.mapleader = " "

            require("gitsigns").setup({
                -- Performance: skip attaching to untracked files
                attach_to_untracked = false,

                on_attach = function(bufnr)
                    local gs = require("gitsigns")

                    -- Helper function to create buffer-local keymaps
                    local function map(mode, lhs, rhs, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, lhs, rhs, opts)
                    end

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

                    -- Toggles for inline blame, deleted lines, and word diffs
                    map("n", "<leader>tb", gs.toggle_current_line_blame)
                    map("n", "<leader>td", gs.toggle_deleted)
                    map("n", "<leader>tw", gs.toggle_word_diff)

                    -- Text object for Git hunk (operator & visual modes)
                    map({ "o", "x" }, "ih", gs.select_hunk)
                end,
            })
        end,
    },
}

