-- Keybinds:
--   gd        : Go to definition
--   <C-k> (in Insert mode) : Show signature help
--   <leader>fm : Manually format buffer + enforce newline at EOF

return {
    {
        -- Plugin: nvim-lspconfig — Built-in LSP client configurations for Neovim
        "neovim/nvim-lspconfig",

        -- Dependencies for automatic LSP installation and formatters
        dependencies = {
            "williamboman/mason.nvim",           -- Package manager for LSP servers, linters, formatters
            "williamboman/mason-lspconfig.nvim", -- Bridges Mason with nvim-lspconfig
            "nvimtools/none-ls.nvim",            -- Null-LS support
            "jay-babu/mason-null-ls.nvim",       -- Bridges Mason with Null-LS
        },

        config = function()
            -- === Module imports ===
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local mason_null_ls = require("mason-null-ls")
            local lspconfig = require("lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local null_ls = require("null-ls")
            local builtins = null_ls.builtins

            -- === LSP servers to ensure installation ===
            local servers = {
                "pyright", "clangd", "gopls", "jsonls", "bashls",
                "dockerls", "yamlls", "terraformls", "rust_analyzer",
                "ts_ls", "lua_ls"
            }

            -- === Formatters / Linters to ensure installation ===
            local formatters = {
                "black", "clang-format", "prettier", "stylua", "gofmt",
                "goimports", "shfmt", "yamlfmt", "terraform_fmt",
            }

            -- === Mason UI setup ===
            mason.setup({ ui = { border = "rounded" } })

            -- === LSP attach function for keymaps ===
            local on_attach = function(_, bufnr)
                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
            end

            -- === Capabilities for completion ===
            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- === Setup LSP servers via Mason ===
            mason_lspconfig.setup({
                ensure_installed = servers,
                handlers = {
                    function(server_name)
                        local opts = { on_attach = on_attach, capabilities = capabilities }

                        -- clangd specific configuration
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
                        end

                        -- gopls specific configuration
                        if server_name == "gopls" then
                            opts.settings = {
                                gopls = {
                                    analyses = { unusedparams = true, nilness = true, unusedwrite = true },
                                    staticcheck = true,
                                },
                            }
                        end

                        -- lua_ls specific configuration
                        if server_name == "lua_ls" then
                            opts.settings = {
                                Lua = {
                                    runtime = {
                                        version = "LuaJIT",
                                        path = vim.split(package.path, ";"),
                                    },
                                    diagnostics = { globals = { "vim" } }, -- recognize vim global
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

            -- === Null-LS setup for formatters and linters ===
            mason_null_ls.setup({ ensure_installed = formatters, automatic_installation = true })

            -- Custom Ruff linter for Python
            local ruff = {
                method = null_ls.methods.DIAGNOSTICS,
                filetypes = { "python" },
                generator = null_ls.generator({
                    command = "ruff",
                    args = { "--format", "json", "--stdin-filename", "$FILENAME", "-" },
                    to_stdin = true,
                    from_stderr = false,
                    format = "json_raw",
                    check_exit_code = function(code) return code <= 1 end,
                    on_output = function(params)
                        local diagnostics = {}
                        local items = params.output or {}
                        for _, item in ipairs(items) do
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
                    builtins.formatting.clang_format,
                    builtins.formatting.prettier,
                    builtins.formatting.stylua,
                    builtins.formatting.gofmt,
                    builtins.formatting.goimports,
                    builtins.formatting.shfmt,
                    builtins.formatting.yamlfmt,
                    builtins.formatting.terraform_fmt,
                    ruff,
                },
            })

            -- === Helper command to install all Mason packages ===
            vim.api.nvim_create_user_command("MasonInstallAll", function()
                vim.cmd("MasonInstall " .. table.concat(servers, " "))
                vim.cmd("MasonInstall " .. table.concat(formatters, " "))
            end, {})

            -- === Diagnostics configuration ===
            vim.diagnostic.config({
                update_in_insert = false,
                virtual_text = false,
                signs = true,
                underline = true,
                severity_sort = true,
            })

            -- Toggle virtual text depending on mode
            vim.api.nvim_create_autocmd("ModeChanged", {
                pattern = "*:n",
                callback = function() vim.diagnostic.config({ virtual_text = true }) end,
            })
            vim.api.nvim_create_autocmd("ModeChanged", {
                pattern = "n:*",
                callback = function() vim.diagnostic.config({ virtual_text = false }) end,
            })

            -- === Manual formatting keymap ===
            vim.keymap.set("n", "<leader>fm", function()
                local bufnr = vim.api.nvim_get_current_buf()
                local clients = vim.lsp.get_clients({ bufnr = bufnr })
                if #clients > 0 then
                    vim.lsp.buf.format({ async = false, bufnr = bufnr })
                end

                -- Ensure buffer ends with a newline
                local last_line = vim.fn.getline("$")
                if last_line ~= "" then vim.fn.append("$", "") end
            end, { noremap = true, silent = true })
        end,
    },
}

