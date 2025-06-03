local M = {
  "mfussenegger/nvim-dap",
  lazy = false,
  dependencies = {

    "rcarriga/nvim-dap-ui",
    dependencies = "nvim-neotest/nvim-nio",
    init = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      vim.keymap.set("n", "<leader>dU", function()
        dapui.toggle({ reset = true })
      end, { desc = "Toggle UI" })
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
              { id = "scopes", size = 20 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "right",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 11,
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
  },
  event = "LspAttach",
  init = function()
    local dap = require("dap")
    vim.keymap.set("n", "<leader>dt", function()
      dap.toggle_breakpoint()
    end, { desc = "Toggle breakpoints" })
    vim.keymap.set("n", "<leader>db", function()
      dap.step_back()
    end, { desc = "Step back" })
    vim.keymap.set("n", "<F5>", function()
      dap.continue()
    end, { desc = "Continue" })
    vim.keymap.set("n", "<leader>ds", function()
      dap.continue()
    end, { desc = "Continue" })
    vim.keymap.set("n", "<leader>dC", function()
      dap.run_to_cursor()
    end, { desc = "Run to cursor" })
    vim.keymap.set("n", "<leader>dd", function()
      dap.disconnect()
    end, { desc = "Disconnect" })
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
      dap.restart()
    end, { desc = "Restart" })

    local icons = require("configs.icons")
    vim.fn.sign_define("DapBreakpoint", { text = icons.ui.Point, numhl = "DapBreakpoint", texthl = "DapBreakpoint" })
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = icons.ui.Point, numhl = "DapBreakpointCondition", texthl = "DapBreakpointCondition" }
    )
    vim.fn.sign_define("DagLogPoint", { text = icons.ui.Unchecked, numhl = "DapLogPoint", texthl = "DapLogPoint" })
    vim.fn.sign_define("DapStopped", { text = icons.ui.Stopped, numhl = "DapStopped", texthl = "DapStopped" })
    vim.fn.sign_define(
      "DapBreakpointRejected",
      { text = icons.ui.Rejected, numhl = "DapBreakpointRejected", texthl = "DapBreakpointRejected" }
    )
  end,

  config = function()
    local files_str = vim.fn.glob(vim.fn.stdpath("config") .. "/dap/*.lua")
    local files_list = vim.split(files_str, "\n", { plain = true })
    for _, file_path in ipairs(files_list) do
      dofile(file_path)
    end
  end,
}

return M
