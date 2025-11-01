return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      -- official Gruvbox palette (medium contrast)
      local colors = {
        bg = "#282828",
        bg2 = "#3c3836",
        fg = "#ebdbb2",
        gray = "#928374",
        red = "#fb4934",
        yellow = "#fabd2f",
        blue = "#83a598",
        purple = "#d3869b",
      }

      local custom = {
        -- Statusline
        StatusLine = { bg = colors.bg2, fg = colors.fg },
        StatusLineNC = { bg = colors.bg2, fg = colors.gray },
        StatusLineError = { bg = colors.bg2, fg = colors.red },
        StatusLineWarn = { bg = colors.bg2, fg = colors.yellow },
        StatusLineHint = { bg = colors.bg2, fg = colors.purple },
        StatusLineInfo = { bg = colors.bg2, fg = colors.blue },

        -- Column bar + window separators
        ColorColumn = { bg = colors.bg2 },
        CursorColumn = { bg = colors.bg2 },
        VertSplit = { bg = colors.bg2, fg = colors.gray },
        WinSeparator = { bg = colors.bg2, fg = colors.gray },

        -- Diagnostics (straight underline + colored virtual text)
        DiagnosticUnderlineError = { underline = true, undercurl = false, sp = colors.red },
        DiagnosticUnderlineWarn = { underline = true, undercurl = false, sp = colors.yellow },
        DiagnosticUnderlineInfo = { underline = true, undercurl = false, sp = colors.blue },
        DiagnosticUnderlineHint = { underline = true, undercurl = false, sp = colors.purple },

        DiagnosticVirtualTextError = { fg = colors.red },
        DiagnosticVirtualTextWarn = { fg = colors.yellow },
        DiagnosticVirtualTextInfo = { fg = colors.blue },
        DiagnosticVirtualTextHint = { fg = colors.purple },
      }

      require("gruvbox").setup({
        contrast = "soft", -- can be "hard", "soft", or empty
        terminal_colors = true,
        bold = true,
        italic = {
          strings = true,
          comments = true,
          operators = false,
          folds = true,
        },
        transparent_mode = true,
        overrides = custom,
      })

      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
    end,
  },
}

