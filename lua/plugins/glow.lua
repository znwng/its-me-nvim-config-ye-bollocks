--[[
Keybinds:
:Glow     -> Open Markdown preview in a floating window
:Glow!    -> Close the preview
]]

return {
    {
        -- Plugin: glow.nvim — Render Markdown previews in Neovim using Glow
        "ellisonleao/glow.nvim",

        -- Lazy-load the plugin when the :Glow command is executed
        cmd = "Glow",

        config = function()
            require("glow").setup({
                style = "dark",     -- Preview style: "dark" or "light"
                width_ratio = 0.8,  -- Maximum width ratio of the preview window (0–1)
                height_ratio = 0.8, -- Maximum height ratio of the preview window (0–1)
                border = "rounded", -- Border style: "none" | "single" | "double" | "rounded" | "shadow"
            })
        end,
    },
}

