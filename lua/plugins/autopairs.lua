--[[
Keybinds / Behavior:
- <CR> (Enter): smart pairing inside brackets/quotes
- <BS> (Backspace): deletes matching pair when appropriate
- Other brackets/quotes auto-close as you type
(No explicit keymaps are required; plugin hooks into Insert mode.)
]]

-- nvim-autopairs: automatically inserts and manages closing brackets, quotes, etc.
return {
    "windwp/nvim-autopairs",

    -- Load the plugin lazily when entering Insert mode to save startup time
    event = "InsertEnter",

    config = function()
        -- Attempt to safely require the plugin
        local ok, npairs = pcall(require, "nvim-autopairs")
        if not ok then return end

        -- Configure the plugin
        npairs.setup({
            -- Use Treesitter to intelligently handle pairing and avoid incorrect inserts
            check_ts = true,

            -- Disable autopairs for certain filetypes where it may interfere
            disable_filetype = { "TelescopePrompt", "vim" },
        })

        -- Optional: integrate autopairs with nvim-cmp completion
        local cmp_ok, cmp = pcall(require, "cmp")
        if cmp_ok then
            -- Load the autopairs completion module
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local handlers = require("nvim-autopairs.completion.handlers")

            -- Attach autopairs behavior to cmp's confirm_done event
            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done({
                    filetypes = {
                        -- disable extra parens for Python
                        python = false,
                        -- keep default behavior for other languages (example: Lua)
                        lua = {
                            ["("] = {
                                kind = {
                                    cmp.lsp.CompletionItemKind.Function,
                                    cmp.lsp.CompletionItemKind.Method,
                                },
                                handler = handlers["*"],
                            }
                        }
                    }
                })
            )
        end
    end,
}

