return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = true,
        integrations = {
          lualine = true,
          treesitter = true,
          telescope = true,
        },
      })

      local bg = "#E6E9Ef" -- mocha background shade
      vim.api.nvim_set_hl(0, "StatusLine", { bg = bg, fg = "#cdd6f4" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = bg, fg = "#6c7086" })
      vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#313244" })
      vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#FB4934", bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#FABD2F", bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#83A598", bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "StatusLineHint", { fg = "#D3869B", bg = "none", bold = true })

      -- Set colorscheme
      vim.cmd("colorscheme catppuccin")
    end,
  },
}

