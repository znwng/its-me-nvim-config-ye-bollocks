--[[
Keybinds / Behavior:
- No default keybinds required.
- Barbecue shows a winbar (breadcrumbs) that updates automatically
  as you move around code.
- Uses nvim-navic for LSP context symbols.
]]

return {
    {
        -- Plugin: barbecue.nvim — displays a winbar with breadcrumbs
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",

        -- Required dependencies
        dependencies = {
            "SmiteshP/nvim-navic",         -- Provides LSP context symbols for breadcrumbs
            "nvim-tree/nvim-web-devicons", -- Adds filetype icons (optional but recommended)
        },

        -- Plugin configuration
        opts = {
            -- Default settings; can be customized later for theme, symbols, separators, etc.
        },
    },
}

