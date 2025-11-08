return {
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      -- UI and message rendering
      view = {
        stack_upwards = true,
        align = "message",
        reflow = false,
        icon_separator = " ",
        group_separator = "---",
        group_separator_hl = "Comment",
        line_margin = 1,
        render_message = function(msg, count)
          return count == 1 and msg or string.format("(%dx) %s", count, msg)
        end,
      },

      -- Notification window settings
      window = {
        normal_hl = "Comment",
        winblend = 0,
        border = "solid",
        zindex = 45,
        max_width = 0,
        max_height = 0,
        x_padding = 1,
        y_padding = 0,
        align = "bottom",
        relative = "editor",
        tabstop = 8,
        avoid = { "NvimTree", "neotest-summary" },
      },

      -- Logging
      logger = {
        level = vim.log.levels.WARN,
        max_size = 10000,
        float_precision = 0.01,
        path = vim.fn.stdpath("cache") .. "/fidget.nvim.log",
      },
    },
  },
}

