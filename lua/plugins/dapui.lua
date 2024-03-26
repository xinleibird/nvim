local M = {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "ofirgall/goto-breakpoints.nvim",
    {
      "mfussenegger/nvim-dap",
      cmd = { "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut", "DapToggleBreakpoint" },
    },
  },
  event = "LspAttach",
  init = function()
    vim.cmd([[command! DapUIClose lua require("dapui").close()]])

    local dap = require("dap")
    local dapui = require("dapui")
    dap.listeners.after.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.after.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.after.event_initialized.dapui_config = function()
      dapui.open()
    end

    dap.listeners.before.disconnect.dapui_config = function()
      -- dap.repl.clear()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      -- dap.repl.clear()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      -- dap.repl.clear()
    end

    vim.keymap.set("n", "<leader>dt", function()
      dap.toggle_breakpoint()
    end, { desc = "Toggle breakpoints" })
    vim.keymap.set("n", "<leader>db", function()
      dap.step_back()
    end, { desc = "Step back" })
    vim.keymap.set("n", "<leader>dc", function()
      dap.continue()
    end, { desc = "Continue" })
    vim.keymap.set("n", "<leader>ds", function()
      dap.continue()
    end, { desc = "Start" })
    vim.keymap.set("n", "<leader>dC", function()
      dap.run_to_cursor()
    end, { desc = "Run to cursor" })
    vim.keymap.set("n", "<leader>dd", function()
      dap.disconnect()
    end, { desc = "Disconnect" })
    vim.keymap.set("n", "<leader>dg", function()
      dap.session()
    end, { desc = "Get session" })
    vim.keymap.set("n", "<leader>di", function()
      dap.step_into()
    end, { desc = "Step into" })
    vim.keymap.set("n", "<leader>do", function()
      dap.step_over()
    end, { desc = "Step over" })
    vim.keymap.set("n", "<leader>du", function()
      dap.step_out()
    end, { desc = "Step out" })
    vim.keymap.set("n", "<leader>dp", function()
      dap.pause()
    end, { desc = "Step pause" })
    vim.keymap.set("n", "<leader>dr", function()
      dap.repl.toggle({ height = 7 }, "lefta split")
    end, { desc = "Step repl toggle" })
    vim.keymap.set("n", "<leader>dq", function()
      dap.close()
    end, { desc = "Quit" })
    vim.keymap.set("n", "<leader>dU", function()
      require("dapui").toggle({ reset = true })
    end, { desc = "Toggle UI" })

    local sign = vim.fn.sign_define
    local icons = require("configs.icons")
    sign("DapBreakpoint", {
      text = icons.ui.Point,
      numhl = "DapBreakpoint",
      texthl = "DapBreakpoint",
    })

    sign("DapBreakpointCondition", {
      text = icons.ui.Point,
      numhl = "DapBreakpointCondition",
      texthl = "DapBreakpointCondition",
    })

    sign("DagLogPoint", {
      text = icons.ui.Unchecked,
      numhl = "DapLogPoint",
      texthl = "DapLogPoint",
    })

    sign("DapStopped", {
      text = icons.ui.Stopped,
      numhl = "DapStopped",
      texthl = "DapStopped",
    })

    sign("DapBreakpointRejected", {
      text = icons.ui.Rejected,
      numhl = "DapBreakpointRejected",
      texthl = "DapBreakpointRejected",
    })

    for _, adapter in ipairs({
      "pwa-extensionHost",
      "node-terminal",
      "pwa-node",
      "pwa-chrome",
      "pwa-msedge",
    }) do
      dap.adapters[adapter] = {
        executable = {
          -- command = "node",
          -- -- 💀 Make sure to update this path to point to your installation
          -- args = { "/path/to/js-debug/src/dapDebugServer.js", "${port}" },
          command = "js-debug-adapter",
          args = { "${port}" },
        },
        host = "localhost",
        port = "${port}",
        type = "server",
      }
    end
    dap.adapters.firefox = {
      command = "firefox-debug-adapter",
      type = "executable",
    }
    dap.adapters.lldb = {
      command = "codelldb",
      type = "executable",
      name = "lldb",
    }

    for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
      dap.configurations[lang] = {
        {
          name = "Launch Chrome",
          reAttach = true,
          request = "launch",
          type = "pwa-chrome",
          url = "http://localhost:8080",
          webRoot = "${workspaceFolder}",
        },
        {
          firefoxExecutable = "/opt/homebrew/bin/firefox",
          name = "Lanuch Firefox",
          reAttach = true,
          request = "launch",
          type = "firefox",
          url = "http://localhost:8080",
          webRoot = "${workspaceFolder}",
        },
        {
          cwd = "${workspaceFolder}",
          name = "Launch with Node",
          program = "${file}",
          request = "launch",
          type = "pwa-node",
          runtimeArgs = {
            "--inspect-brk",
          },
        },
        {
          cwd = "${workspaceFolder}",
          name = "Attach into Node",
          processId = require("dap.utils").pick_process,
          request = "attach",
          type = "pwa-node",
        },
      }
    end
    dap.configurations.cpp = {
      {
        name = "Launch file",
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
    dap.configurations.rust = {
      {
        name = "Launch file",
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
  end,
  opts = function()
    return {
      icons = { expanded = "▾", collapsed = "▸" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      expand_lines = false,
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.40 },
            { id = "breakpoints", size = 0.20 },
            { id = "stacks", size = 0.20 },
            { id = "watches", size = 0.20 },
          },
          size = 0.25,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 0.25,
          position = "bottom",
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = "rounded", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil,
      },
    }
  end,

  config = function(_, opts)
    require("dapui").setup(opts)
  end,
}

return M
