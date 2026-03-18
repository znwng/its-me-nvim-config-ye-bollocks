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
                "rust_analyzer",
                "bashls",
                "lua_ls",
                "tinymist",
                "jdtls",
            }

            local formatters_and_linters = {
                "black",
                "clang-format",
                "prettier",
                "goimports",
                "golangci-lint",
                "shfmt",
                "stylua",
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
                                    analyses = {
                                        unusedparams = true,
                                        shadow = true,
                                        nilness = true,
                                        unusedwrite = true,
                                    },
                                    staticcheck = true,
                                    hints = {
                                        assignVariableTypes = true,
                                        compositeLiteralFields = true,
                                        parameterNames = true,
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
                        elseif server_name == "jdtls" then
                            opts.cmd = { "jdtls" }
                            opts.root_dir =
                                lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle")
                            opts.settings = {
                                java = {
                                    eclipse = { downloadSources = true },
                                    configuration = {
                                        updateBuildConfiguration = "interactive",
                                    },
                                    maven = { downloadSources = true },
                                    format = {
                                        enabled = true,
                                        settings = {
                                            url = nil,
                                            profile = "GoogleStyle",
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
                    builtins.formatting.prettier.with({
                        filetypes = {
                            "markdown",
                        },
                    }),
                    builtins.formatting.shfmt,
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

            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

            vim.keymap.set("n", "<leader>fm", function()
                local bufnr = vim.api.nvim_get_current_buf()

                vim.lsp.buf.format({
                    bufnr = bufnr,
                    async = false,
                })

                local last_line = vim.api.nvim_buf_get_lines(bufnr, -2, -1, false)[1]
                if last_line ~= "" then
                    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { "" })
                end
            end, { noremap = true, silent = true })
        end,
    },
}

