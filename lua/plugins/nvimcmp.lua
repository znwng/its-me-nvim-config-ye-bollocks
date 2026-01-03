--[[
nvim-cmp (Autocompletion)

Keybindings:
<C-Space> -> Open completion menu
<CR>      -> Confirm selected item
<Tab>     -> Next item / expand or jump in snippet
<S-Tab>   -> Previous item / jump back in snippet
]]

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
      "windwp/nvim-autopairs",
    },

    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),

        window = {
          completion = cmp.config.window.bordered({
            border = "single",
          }),
          documentation = cmp.config.window.bordered({
            border = "single",
          }),
        },

        formatting = {
          fields = { "abbr", "kind" },
          format = function(_, vim_item)
            local icon = lspkind.symbolic(vim_item.kind, { mode = "symbol" }) or ""
            vim_item.kind = string.format("%s %s", icon, vim_item.kind or "")
            vim_item.menu = ""
            return vim_item
          end,
        },
      })

      -- Autopairs integration
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("nvim-autopairs").setup({})
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- === Catppuccin Mocha palette ===
      local cp = require("catppuccin.palettes").get_palette()
      local bg = "NONE" -- transparent

      -- === Apply Catppuccin highlights ===
      vim.api.nvim_set_hl(0, "CmpPmenu", { bg = bg, fg = cp.text })
      vim.api.nvim_set_hl(0, "CmpPmenuSel", { bg = cp.base, fg = cp.sky, bold = true })
      vim.api.nvim_set_hl(0, "CmpBorder", { fg = cp.surface0, bg = bg })
      vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = cp.surface0, bg = bg })

      -- Fallbacks (in case something uses Pmenu directly)
      vim.api.nvim_set_hl(0, "Pmenu", { bg = bg, fg = cp.text })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = cp.base, fg = cp.sky })
    end,
  },
}

