--[[
Keybinds:
gd        -> Go to definition
<C-k>     -> Show signature help in insert mode
<leader>fm -> Format buffer + ensure newline at EOF
]]

return {
	{
		-- Neovim LSP configurations
		"neovim/nvim-lspconfig",

		dependencies = {
			"williamboman/mason.nvim", -- Manage external LSP servers
			"williamboman/mason-lspconfig.nvim", -- Bridge Mason with LSPConfig
			"nvimtools/none-ls.nvim", -- Setup null-ls
			"jay-babu/mason-null-ls.nvim", -- Mason support for null-ls
		},

		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_null_ls = require("mason-null-ls")
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local null_ls = require("null-ls")
			local builtins = null_ls.builtins

			-- List of LSP servers to ensure installed
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
				"jdtls",
				"tinymist",
			}

			-- List of formatters / linters
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
			}

			-- Mason setup
			mason.setup()

			-- Function to run when LSP attaches to a buffer
			local on_attach = function(_, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
			end

			-- Capabilities for LSP completion
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- Setup LSP servers using Mason
			mason_lspconfig.setup({
				ensure_installed = servers,
				handlers = {
					function(server_name)
						local opts = { on_attach = on_attach, capabilities = capabilities }

						-- Special options for clangd
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

						-- Special options for Java (jdtls)
						if server_name == "jdtls" then
							local jdtls_cmd = {
								"java",
								"-Xms256m",
								"-Xmx1024m",
								"-XX:+UseG1GC",
								"-jar",
								vim.fn.stdpath("data") .. "/mason/bin/jdtls/plugins/org.eclipse.equinox.launcher_*.jar",
								"-configuration",
								vim.fn.stdpath("data") .. "/mason/bin/jdtls/config",
								"-data",
								vim.fn.stdpath("data") .. "/jdtls-workspace",
							}
							opts.cmd = jdtls_cmd
							opts.root_dir =
								lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle")
							opts.single_file_support = false
							opts.settings = {
								java = {
									format = { enabled = true },
									signatureHelp = { enabled = true },
									completion = {
										favoriteStaticMembers = {
											"org.junit.Assert.*",
											"org.junit.Assume.*",
											"org.junit.jupiter.api.Assertions.*",
										},
									},
									contentProvider = { preferred = "fernflower" },
								},
							}
							vim.api.nvim_create_autocmd("BufWritePre", {
								pattern = "*.java",
								callback = function()
									vim.lsp.buf.format({ async = false })
								end,
							})
						end

						-- Special options for gopls
						if server_name == "gopls" then
							opts.settings = {
								gopls = {
									analyses = { unusedparams = true, nilness = true, unusedwrite = true },
									staticcheck = true,
								},
							}
						end

						-- Special options for Lua (lua_ls)
						if server_name == "lua_ls" then
							opts.settings = {
								Lua = {
									runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
									diagnostics = { globals = { "vim" } },
									workspace = {
										library = vim.api.nvim_get_runtime_file("", true),
										checkThirdParty = false,
									},
									telemetry = { enable = false },
								},
							}
						end

						-- Apply LSP config
						lspconfig[server_name].setup(opts)
					end,
				},
			})

			-- Setup null-ls formatters and linters
			mason_null_ls.setup({ ensure_installed = formatters, automatic_installation = true })

			-- Custom null-ls sources
			local typstfmt = {
				method = null_ls.methods.FORMATTING,
				filetypes = { "typst" },
				generator = null_ls.formatter({
					command = "typstfmt",
					args = { "$FILENAME" },
					to_temp_file = true,
				}),
			}

			local ruff = {
				method = null_ls.methods.DIAGNOSTICS,
				filetypes = { "python" },
				generator = null_ls.generator({
					command = "ruff",
					args = { "--format", "json", "--stdin-filename", "$FILENAME", "-" },
					to_stdin = true,
					from_stderr = false,
					format = "json_raw",
					check_exit_code = function(code)
						return code <= 1
					end,
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

			local eclipse_formatter = {
				method = null_ls.methods.FORMATTING,
				filetypes = { "java" },
				generator = null_ls.generator({
					command = "java",
					args = { "-jar", vim.fn.expand("~/.local/bin/ecj.jar") },
					to_stdin = true,
					on_output = function(params)
						return params.output
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
					eclipse_formatter,
					ruff,
					typstfmt,
				},
			})

			-- Command to install all LSP servers + formatters
			vim.api.nvim_create_user_command("MasonInstallAll", function()
				vim.cmd("MasonInstall " .. table.concat(servers, " "))
				vim.cmd("MasonInstall " .. table.concat(formatters, " "))
			end, {})

			-- Configure diagnostics display
			vim.diagnostic.config({
				update_in_insert = false,
				virtual_text = true,
				signs = true,
				underline = true,
				severity_sort = true,
			})

			-- Manual format keymap (<leader>fm)
			vim.keymap.set("n", "<leader>fm", function()
				local bufnr = vim.api.nvim_get_current_buf()
				for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
					if client.supports_method("textDocument/formatting") then
						vim.lsp.buf.format({ async = false, bufnr = bufnr })
						break
					end
				end
				-- Ensure newline at EOF
				local last_line = vim.fn.getline("$")
				if last_line ~= "" then
					vim.fn.append("$", "")
				end
			end, { noremap = true, silent = true })
		end,
	},
}

