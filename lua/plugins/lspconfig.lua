-- Keybinds:
-- gd         → Go to definition
-- <C-k>      → Show signature help (insert mode)
-- <leader>fm → Format buffer + ensure newline at EOF

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "nvimtools/none-ls.nvim",
      "jay-babu/mason-null-ls.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      vim.env.PATH = vim.env.PATH .. ":/home/zenwing/.local/bin"

      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local mason_null_ls = require("mason-null-ls")
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local null_ls = require("null-ls")
      local builtins = null_ls.builtins

      local servers = {
        "pyright",
        "clangd",
        "gopls",
        "jsonls",
        "bashls",
        "dockerls",
        "yamlls",
        "terraformls",
        "rust_analyzer",
        "ts_ls",
        "lua_ls",
        "tinymist",
        "cmake",
      }

      local formatters = {
        "black",
        "clang-format",
        "prettier",
        "stylua",
        "gofmt",
        "goimports",
        "shfmt",
        "yamlfmt",
        "terraform_fmt",
        "typstyle",
      }

      mason.setup()

      local capabilities = cmp_nvim_lsp.default_capabilities()

      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
      end

      mason_lspconfig.setup({
        ensure_installed = servers,
        handlers = {
          function(server_name)
            local opts = { on_attach = on_attach, capabilities = capabilities }

            if server_name == "clangd" then
              opts.cmd = {
                "clangd",
                "--compile-commands-dir=build",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=never",
                "--completion-style=detailed",
              }
              opts.root_dir = lspconfig.util.root_pattern(".clangd", "compile_commands.json", ".git")
            elseif server_name == "gopls" then
              opts.settings = {
                gopls = {
                  analyses = { unusedparams = true, nilness = true, unusedwrite = true },
                  staticcheck = true,
                },
              }
            elseif server_name == "lua_ls" then
              opts.settings = {
                Lua = {
                  runtime = { version = "LuaJIT" },
                  diagnostics = { globals = { "vim" } },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  telemetry = { enable = false },
                },
              }
            end

            lspconfig[server_name].setup(opts)
          end,
        },
      })

      mason_null_ls.setup({
        ensure_installed = formatters,
        automatic_installation = true,
      })

      local ruff = {
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "python" },
        generator = null_ls.generator({
          command = "ruff",
          args = { "--format", "json", "--stdin-filename", "$FILENAME", "-" },
          to_stdin = true,
          format = "json_raw",
          check_exit_code = function(code)
            return code <= 1
          end,
          on_output = function(params)
            local diagnostics = {}
            for _, item in ipairs(params.output or {}) do
              table.insert(diagnostics, {
                row = item.location.row,
                col = item.location.column,
                end_row = item.location.end_row,
                end_col = item.location.end_column,
                source = "ruff",
                message = item.message,
                severity = ({
                  E = vim.diagnostic.severity.ERROR,
                  F = vim.diagnostic.severity.ERROR,
                  W = vim.diagnostic.severity.WARN,
                  I = vim.diagnostic.severity.INFO,
                  H = vim.diagnostic.severity.HINT,
                })[item.code:sub(1, 1)] or vim.diagnostic.severity.WARN,
                code = item.code,
              })
            end
            return diagnostics
          end,
        }),
      }

      null_ls.setup({
        sources = {
          builtins.formatting.black,
          ruff,
          builtins.formatting.clang_format,
          builtins.formatting.gofmt,
          builtins.formatting.goimports,
          builtins.formatting.stylua,
          builtins.formatting.shfmt,
          builtins.formatting.prettier,
          builtins.formatting.yamlfmt,
          builtins.formatting.terraform_fmt,
          builtins.formatting.typstyle.with({
            extra_args = { "--indent-width", "4", "--line-width", "80" },
          }),
        },
      })

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        local all = vim.list_extend(vim.deepcopy(servers), formatters)
        vim.cmd("MasonInstall " .. table.concat(all, " "))
      end, {})

      vim.diagnostic.config({
        update_in_insert = false,
        virtual_text = true,
        signs = true,
        underline = true,
        severity_sort = true,
      })

      vim.keymap.set("n", "<leader>fm", function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.lsp.buf.format({ async = false, bufnr = bufnr })
        if vim.fn.getline("$") ~= "" then
          vim.fn.append("$", "")
        end
      end, { noremap = true, silent = true })
    end,
  },
}

