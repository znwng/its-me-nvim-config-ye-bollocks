--[[
Keybinds / Behavior:
- No default keybinds required.
- Barbecue shows a winbar (breadcrumbs) that updates automatically
  as you move around code.
- Uses nvim-navic for LSP context symbols.
]]

return {
    {
        -- Plugin: barbecue.nvim — winbar breadcrumbs
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",

        -- Required dependencies
        dependencies = {
            "SmiteshP/nvim-navic",         -- LSP context provider
            "nvim-tree/nvim-web-devicons", -- icons (optional but recommended)
        },

        -- Plugin configuration
        opts = {
            -- You can leave empty for defaults,
            -- or customize later (theme, symbols, separators, etc.)
        },
    },
}

