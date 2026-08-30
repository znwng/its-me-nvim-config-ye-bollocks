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
                "ols",
                "lua_ls",
                "docker_compose_language_service",
                "docker_language_server",
                "dockerls",
                "matlab_ls",
                "tinymist",
            }

            local formatters_and_linters = {
                "black",
                "clang-format",
                "goimports",
                "golangci-lint",
                "shfmt",
                "odinfmt",
                "stylua",
            }

            mason.setup()

            local capabilities = cmp_nvim_lsp.default_capabilities()

            local on_attach = function(_, bufnr)
                local opts = {
                    noremap = true,
                    silent = true,
                    buffer = bufnr,
                }

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
                        elseif server_name == "ols" then
                            opts.settings = {
                                enable_format = true,
                            }
                        elseif server_name == "lua_ls" then
                            opts.settings = {
                                Lua = {
                                    runtime = {
                                        version = "LuaJIT",
                                    },
                                    diagnostics = {
                                        globals = { "vim" },
                                    },
                                    workspace = {
                                        library = vim.api.nvim_get_runtime_file("", true),
                                        checkThirdParty = false,
                                    },
                                    telemetry = {
                                        enable = false,
                                    },
                                },
                            }
                        end

                        lspconfig[server_name].setup(opts)
                    end,
                },
            })

            vim.lsp.config("arduino_language_server", {
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = {
                    "arduino-language-server",
                    "-cli",
                    "arduino-cli",
                    "-cli-config",
                    vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
                    "-clangd",
                    "clangd",
                    "-fqbn",
                    "esp32:esp32:esp32",
                },
            })

            vim.lsp.enable("arduino_language_server")

            vim.lsp.config("tinymist", {
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = {
                    "/usr/local/bin/tinymist",
                },
                filetypes = {
                    "typst",
                },
                root_markers = {
                    "typst.toml",
                    ".git",
                },
            })

            vim.lsp.enable("tinymist")

            local typstyle = null_ls.builtins.formatting.stylua.with({
                name = "typstyle",
                command = "/usr/local/bin/typstyle",
                filetypes = { "typst" },
                args = {
                    "--line-width",
                    "120",
                    "--indent-width",
                    "4",
                },
            })

            local odinfmt = null_ls.builtins.formatting.stylua.with({
                name = "odinfmt",
                command = "odinfmt",
                filetypes = { "odin" },
                args = {
                    "-stdin",
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
                    builtins.diagnostics.golangci_lint,
                    typstyle,
                    odinfmt,
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
                float = {
                    border = "rounded",
                },
            })

            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

            vim.keymap.set("n", "<leader>fm", function()
                vim.lsp.buf.format({
                    bufnr = vim.api.nvim_get_current_buf(),
                    async = false,
                })
            end, {
                noremap = true,
                silent = true,
            })

            vim.keymap.set("n", "<leader>a", function()
                vim.diagnostic.setloclist()
                vim.cmd("lopen")
            end, {
                noremap = true,
                silent = true,
            })

            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
                noremap = false,
                silent = false,
            })

            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
                noremap = false,
                silent = false,
            })

            vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
                noremap = true,
                silent = true,
            })
        end,
    },
}
