--[[
Keybindings for nvim-dap:

<F5>        -> Start/Continue debugging
<F10>       -> Step over
<F11>       -> Step into
<F12>       -> Step out
<Leader>db  -> Toggle breakpoint
<Leader>dB  -> Set conditional breakpoint
<Leader>dr  -> Open debug console (REPL)
<Leader>du  -> Toggle DAP UI
]]

return {
	{
		-- Plugin: nvim-dap — Debug Adapter Protocol integration for Neovim
		"mfussenegger/nvim-dap",

		-- Required plugins for UI, Python, inline variables, etc.
		dependencies = {
			"rcarriga/nvim-dap-ui", -- UI panels for DAP
			"mfussenegger/nvim-dap-python", -- Python adapter setup
			"theHamsta/nvim-dap-virtual-text", -- Inline variable display
			"nvim-neotest/nvim-nio", -- Needed by dap-ui
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local dap_python = require("dap-python")

			-- Python debugger setup
			dap_python.setup("python")

			-- DAP UI panels setup
			dapui.setup()

			-- Show virtual text (inline variable values)
			require("nvim-dap-virtual-text").setup()

			-- Adapter config for C/C++ via LLDB
			dap.adapters.lldb = {
				type = "executable",
				command = "/usr/lib/llvm-18/bin/lldb-dap", -- Adjust path if needed
				name = "lldb",
			}

			-- Debug config for C++
			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "lldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
			}

			-- Use same setup for C
			dap.configurations.c = dap.configurations.cpp

			-- Key mappings for common debug actions
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
			vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<Leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Set Conditional Breakpoint" })
			vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "Open Debug Console (REPL)" })
			vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
		end,
	},
}
