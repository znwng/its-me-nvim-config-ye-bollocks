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

            local formatters_and_linters = {
                "black",
                "clang-format",
                "prettier",
                "stylua",
                "goimports",
                "shfmt",
                "yamlfmt",
                "terraform_fmt",
                "typstyle",
                "golangci-lint",
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
                        local opts = {
                            on_attach = on_attach,
                            capabilities = capabilities,
                        }

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
                                    analyses = {
                                        unusedparams = true,
                                        nilness = true,
                                        unusedwrite = true,
                                    },
                                    staticcheck = true,

                                    codelenses = {
                                        gc_details = true,
                                        generate = true,
                                        regenerate_cgo = true,
                                        run_govulncheck = true,
                                        test = true,
                                        tidy = true,
                                        upgrade_dependency = true,
                                        vendor = true,
                                    },

                                    hints = {
                                        assignVariableTypes = true,
                                        compositeLiteralFields = true,
                                        compositeLiteralTypes = true,
                                        constantValues = true,
                                        functionTypeParameters = true,
                                        parameterNames = true,
                                        rangeVariableTypes = true,
                                    },
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
                        elseif server_name == "rust_analyzer" then
                            opts.settings = {
                                ["rust-analyzer"] = {
                                    cargo = {
                                        allFeatures = true,
                                        loadOutDirsFromCheck = true,
                                        buildScripts = { enable = true },
                                    },
                                    procMacro = { enable = true },
                                    checkOnSave = {
                                        command = "clippy",
                                        extraArgs = { "--no-deps" },
                                    },
                                    inlayHints = {
                                        bindingModeHints = { enable = true },
                                        chainingHints = { enable = true },
                                        closingBraceHints = {
                                            enable = true,
                                            minLines = 25,
                                        },
                                        closureReturnTypeHints = { enable = "always" },
                                        lifetimeElisionHints = {
                                            enable = "always",
                                            useParameterNames = true,
                                        },
                                        parameterHints = { enable = true },
                                        reborrowHints = { enable = "always" },
                                        typeHints = {
                                            enable = true,
                                            hideClosureInitialization = false,
                                            hideNamedConstructor = false,
                                        },
                                    },
                                },
                            }
                        end

                        lspconfig[server_name].setup(opts)
                    end,
                },
            })

            mason_null_ls.setup({
                ensure_installed = formatters_and_linters,
                automatic_installation = true,
            })

            null_ls.setup({
                sources = {
                    builtins.formatting.black,
                    builtins.formatting.clang_format,
                    builtins.formatting.goimports,
                    builtins.formatting.stylua,
                    builtins.formatting.shfmt,
                    builtins.formatting.prettier,
                    builtins.formatting.yamlfmt,
                    builtins.formatting.terraform_fmt,
                    builtins.formatting.typstyle.with({
                        extra_args = { "--indent-width", "4", "--line-width", "80" },
                    }),

                    builtins.diagnostics.golangci_lint,
                },
            })

            vim.api.nvim_create_user_command("MasonInstallAll", function()
                local all = vim.list_extend(vim.deepcopy(servers), formatters_and_linters)
                vim.cmd("MasonInstall " .. table.concat(all, " "))
            end, {})

            vim.diagnostic.config({
                update_in_insert = false,
                virtual_text = true,
                signs = true,
                underline = true,
                severity_sort = true,
                float = { border = "rounded" },
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

