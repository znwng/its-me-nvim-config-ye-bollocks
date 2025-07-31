return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"nvimtools/none-ls.nvim",
			"jay-babu/mason-null-ls.nvim",
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
			}

			mason.setup({
				ui = { border = "rounded" },
			})

			local on_attach = function(client, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
			end

			local capabilities = cmp_nvim_lsp.default_capabilities()

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
						end

						lspconfig[server_name].setup(opts)
					end,

					["gopls"] = function()
						lspconfig.gopls.setup({
							on_attach = on_attach,
							capabilities = capabilities,
							settings = {
								gopls = {
									analyses = {
										unusedparams = true,
										nilness = true,
										unusedwrite = true,
									},
									staticcheck = true,
								},
							},
						})
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

			vim.api.nvim_create_user_command("MasonInstallAll", function()
				vim.cmd("MasonInstall " .. table.concat(servers, " "))
				vim.cmd("MasonInstall " .. table.concat(formatters, " "))
			end, {})

			vim.diagnostic.config({
				update_in_insert = false,
				virtual_text = false,
				signs = true,
				underline = true,
				severity_sort = true,
			})

			vim.api.nvim_create_autocmd("ModeChanged", {
				pattern = "*:n",
				callback = function()
					vim.diagnostic.config({ virtual_text = true })
				end,
			})

			vim.api.nvim_create_autocmd("ModeChanged", {
				pattern = "n:*",
				callback = function()
					vim.diagnostic.config({ virtual_text = false })
				end,
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function()
					vim.cmd([[%s/\s\+$//e]])
					vim.lsp.buf.format({ async = false })
				end,
			})

			vim.keymap.set("n", "<leader>fm", function()
				vim.lsp.buf.format({ async = false })
			end, { noremap = true, silent = true })
		end,
	},
}
