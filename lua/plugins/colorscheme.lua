return {
  {
    "alexpasmantier/hubbamax.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme hubbamax")

      -- Transparent background for editor
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

      -- Statusline background
      local bg = "#282828"
      vim.api.nvim_set_hl(0, "StatusLine", { bg = bg, fg = "#92969e" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = bg, fg = "#A3BE8C" })

      -- ColorColumn
      vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#2E2E2E" })

      -- Diagnostics colors for statusline
      vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#FB4934", bg = bg, bold = true })
      vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#FABD2F", bg = bg, bold = true })
      vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#83A598", bg = bg, bold = true })
      vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#D3869B", bg = bg, bold = true })

      -- Italic comments
      vim.api.nvim_set_hl(0, "@comment", { fg = "#656565", italic = true })
    end,
  },
}

