--[[
Telescope.nvim (fuzzy finder)

Keymaps:
<leader>ff -> Find files (shows hidden files too)
<leader>fg -> Live grep
<leader>fb -> Open buffers list
<leader>fh -> Help tags

Buffer navigation:
<Tab>     -> Next buffer
<S-Tab>   -> Previous buffer
]]

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    config = function()
      local cp = require("catppuccin.palettes").get_palette()
      local colors = {
        bg = "NONE", -- transparent background
        bg2 = cp.base, -- slightly darker selection
        fg = cp.text, -- main text
        accent = cp.sky, -- Catppuccin mocha cyan accent
        border = cp.surface0, -- subtle border
      }

      require("telescope").setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },
          winblend = 0,
          color_devicons = true,
          border = true,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },
        pickers = {
          find_files = { hidden = true },
        },
      })

      -- Telescope highlights using Catppuccin colors
      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none", fg = colors.fg })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = colors.border, bg = colors.bg })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = colors.border, bg = colors.bg })
      vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = colors.bg })
      vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = colors.accent })
      vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = colors.accent, bg = "none", bold = true })
      vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = colors.accent, bg = "none", bold = true }) -- transparent caret

      -- Keymaps for Telescope
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
      keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
      keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
      keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

      -- Buffer navigation
      keymap("n", "<Tab>", "<cmd>bnext<CR>", opts)
      keymap("n", "<S-Tab>", "<cmd>bprevious<CR>", opts)
    end,
  },
}

