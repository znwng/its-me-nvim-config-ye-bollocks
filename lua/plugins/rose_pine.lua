--[[
Colorscheme: rose-pine

Variants available:
  - main (default)
  - moon
  - dawn

Extra Highlights:
  - Diagnostics underlined instead of squiggly for clarity
]]

return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,    -- Load immediately
    priority = 1000, -- Make sure this loads before all other plugins

    config = function()
        -- Setup rose-pine with custom options
        require("rose-pine").setup({
            variant = "moon",          -- 'main', 'moon', or 'dawn'
            disable_background = true, -- Transparent background
            styles = {
                italic = false,
                bold = false,
            },
        })

        -- Apply colorscheme
        vim.cmd.colorscheme("rose-pine")

        -- Override diagnostic highlights (underline instead of squiggly)
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = false, underline = true })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = false, underline = true })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = false, underline = true })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = false, underline = true })
    end,
}

