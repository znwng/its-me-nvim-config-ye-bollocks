--[[
Treesitter text objects and movement:

Text Objects:
af -> Select entire function
if -> Select inside function
ac -> Select entire class
ic -> Select inside class

Usage examples:
vaf  -> Visually select a function
yif  -> Yank (copy) inside of function
daf  -> Delete a function
cic  -> Change inside class

Movement:
]m   -> Jump to next function
[m   -> Jump to previous function
]]

return {
  {
    -- Treesitter: syntax highlighting, indentation, and text objects
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    -- Textobject support
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },

    config = function()
      require("nvim-treesitter.configs").setup({
        -- Install parsers for these languages
        ensure_installed = {
          "python",
          "c",
          "cpp",
          "lua",
          "markdown",
          "markdown_inline",
          "go",
          "rust",
          "java",
          "javascript",
          "typescript",
          "typst",
        },

        sync_install = false, -- Install asynchronously

        -- Syntax highlighting
        highlight = { enable = true, disable = {} },

        -- Indentation based on Treesitter
        indent = { enable = true },

        -- Textobjects configuration
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Jump forward automatically
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- Record jumps in jumplist
            goto_next_start = { ["]m"] = "@function.outer" },
            goto_previous_start = { ["[m"] = "@function.outer" },
          },
        },
      })

      -- Set global indentation: 4 spaces, expand tabs
      vim.api.nvim_exec(
        [[
                augroup global_indent
                  autocmd!
                  autocmd FileType * setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
                augroup END
            ]],
        false
      )
    end,
  },

  {
    -- Render Markdown directly in Neovim
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      require("render-markdown").setup({
        latex = { enabled = false }, -- Disable LaTeX rendering
        html = { enabled = false }, -- Disable HTML rendering
      })
    end,
  },
}

