--[[
Keybinds / Behavior:
- <CR> (Enter): smart pairing inside brackets/quotes
- <BS> (Backspace): deletes matching pair when appropriate
- Other brackets/quotes auto-close as you type
(No explicit keymaps needed; plugin hooks into Insert mode)
]]

-- Plugin: nvim-autopairs — automatically closes brackets, quotes, etc.
return {
  "windwp/nvim-autopairs",

  -- Load lazily on Insert mode for faster startup
  event = "InsertEnter",

  config = function()
  -- Safely require the plugin
  local ok, npairs = pcall(require, "nvim-autopairs")
    if not ok then
      return
    end

    -- Setup autopairs
    npairs.setup({
      check_ts = true, -- Use Treesitter to avoid wrong pair inserts
      disable_filetype = { "TelescopePrompt", "vim" }, -- Disable in specific filetypes
    })

    -- Optional: integrate with nvim-cmp completion
    local cmp_ok, cmp = pcall(require, "cmp")
    if cmp_ok then
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local handlers = require("nvim-autopairs.completion.handlers")

      -- Attach autopairs to completion confirm event
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done({
          filetypes = {
            python = false, -- disable extra parens for Python
            lua = { -- customize for Lua functions/methods
              ["("] = {
                kind = {
                  cmp.lsp.CompletionItemKind.Function,
                  cmp.lsp.CompletionItemKind.Method,
                },
                handler = handlers["*"],
              },
            },
          },
        })
      )
    end
  end,
}

