--[[
Keybinds / Behavior:
- <CR> (Enter): smart pairing inside brackets/quotes
- <BS> (Backspace): deletes matching pair when appropriate
- Other brackets/quotes auto-close as you type
(No explicit keymaps are required; plugin hooks into Insert mode.)
]]

-- nvim-autopairs: automatically close brackets, quotes, etc.
return {
    "windwp/nvim-autopairs",

    -- Lazy-load the plugin only when entering Insert mode
    event = "InsertEnter",

    config = function()
        -- Safely load the plugin
        local ok, npairs = pcall(require, "nvim-autopairs")
        if not ok then return end

        npairs.setup({
            -- Enable Treesitter-based checks to avoid incorrect pairing
            check_ts = true,

            -- Filetypes where autopairs should be disabled
            disable_filetype = { "TelescopePrompt", "vim" },
        })

        -- Optional: integrate with nvim-cmp if it exists
        local cmp_ok, cmp = pcall(require, "cmp")
        if cmp_ok then
            -- Load the completion bridge
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            -- Hook autopairs into cmp's confirm_done event
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    end,
}

