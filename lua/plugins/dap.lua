--[[
Keybinds:
<F5>        -> Start / Continue debugging
<F10>       -> Step over
<F11>       -> Step into
<F12>       -> Step out
<leader>b   -> Toggle breakpoint
<leader>B   -> Conditional breakpoint
<leader>dr  -> Open DAP REPL
<leader>drc -> Close DAP REPL
<leader>dl  -> Run last debug session
<leader>du  -> Close DAP UI
]]

return {
  {
    -- Core debugger
    "mfussenegger/nvim-dap",

    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- UI + virtual text
      dapui.setup({
        floating = { border = "rounded" },
      })

      require("nvim-dap-virtual-text").setup()

      dap.listeners.after.event_initialized["dapui"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui"] = function()
        dapui.close()
      end

      -- Gruvbox highlights
      local function dap_gruvbox()
        vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#fb4934" })
        vim.api.nvim_set_hl(0, "DapStopped", { fg = "#b8bb26" })
        vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#fabd2f" })
      end

      dap_gruvbox()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = dap_gruvbox,
      })

      vim.fn.sign_define("DapBreakpoint", {
        text = "●",
        texthl = "DapBreakpoint",
      })

      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DapStopped",
      })

      vim.fn.sign_define("DapLogPoint", {
        text = "",
        texthl = "DapLogPoint",
      })

      -- Keybindings
      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<F12>", dap.step_out)

      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end)

      vim.keymap.set("n", "<leader>dr", dap.repl.open) -- Open DAP REPL
      vim.keymap.set("n", "<leader>drc", function()
        dap.repl.close()
      end) -- Close DAP REPL
      vim.keymap.set("n", "<leader>dl", dap.run_last) -- Run last debug session
      vim.keymap.set("n", "<leader>du", function()
        dapui.close()
      end) -- Close DAP UI

      -- C / C++ / Rust (codelldb)
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.expand("~/.local/share/codelldb/extension/adapter/codelldb"),
          args = { "--port", "${port}" },
        },
      }

      local codelldb_config = {
        {
          name = "Launch executable",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.c = codelldb_config
      dap.configurations.cpp = codelldb_config
      dap.configurations.rust = codelldb_config

      -- Python (debugpy)
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = "python",
        },
      }

      -- Go (delve)
      dap.adapters.go = {
        type = "executable",
        command = "dlv",
        args = { "dap" },
      }

      dap.configurations.go = {
        {
          type = "go",
          name = "Debug file",
          request = "launch",
          program = "${file}",
        },
        {
          type = "go",
          name = "Debug package",
          request = "launch",
          program = "${workspaceFolder}",
        },
      }
    end,
  },
}

