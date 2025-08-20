--[[
Keybinds:
:Glow     -> Open Markdown preview in a floating window
:Glow!    -> Close the preview
]]

return {
    {
        -- Plugin: glow.nvim — Markdown preview in Neovim using Glow
        "ellisonleao/glow.nvim",

        -- Load only when needed (lazy load on command)
        cmd = "Glow",

        config = function()
            require("glow").setup({
                style = "dark",     -- Glow style: "dark" | "light"
                width_ratio = 0.8,  -- Max width ratio of the preview window (0–1)
                height_ratio = 0.8, -- Max height ratio of the preview window (0–1)
                border = "rounded", -- Border style: "none" | "single" | "double" | "rounded" | "shadow"
            })
        end,
    },
}

