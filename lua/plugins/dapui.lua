local M = {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "ofirgall/goto-breakpoints.nvim",
    {
      "mfussenegger/nvim-dap",
      cmd = { "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut", "DapToggleBreakpoint" },
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        commented = true,
      },
    },
  },
  event = "LspAttach",
  init = function()
    local init_dap = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_virtual_text = require("nvim-dap-virtual-text")

      -- dap.listeners.before.event_initialized["dapui_config"] = function()
      --   local api = require("nvim-tree.api")
      --   local view = require("nvim-tree.view")
      --   if view.is_visible() then
      --     api.tree.close()
      --   end
      --
      --   for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      --     local bufnr = vim.api.nvim_win_get_buf(winnr)
      --     if vim.api.nvim_get_option_value("ft", { buf = bufnr }) == "dap-repl" then
      --       return
      --     end
      --   end
      --   -- dapui:open()
      -- end

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
        dap_virtual_text.refresh()
      end

      dap.listeners.after.disconnect["dapui_config"] = function()
        require("dap.repl").close()
        dapui.close()
        dap_virtual_text.refresh()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
        dap_virtual_text.refresh()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
        dap_virtual_text.refresh()
      end
    end

    local setup_keymaps = function()
      local dap = require("dap")
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
      end, { desc = "Run to Cursor" })

      vim.keymap.set("n", "<leader>dd", function()
        dap.disconnect()
      end, { desc = "Disconnect" })

      vim.keymap.set("n", "<leader>dg", function()
        dap.session()
      end, { desc = "Get session" })

      vim.keymap.set("n", "<leader>di", function()
        dap.step_into()
      end, { desc = "Step Into" })

      vim.keymap.set("n", "<leader>do", function()
        dap.step_over()
      end, { desc = "Step Over" })

      vim.keymap.set("n", "<leader>du", function()
        dap.step_out()
      end, { desc = "Step oUt" })

      vim.keymap.set("n", "<leader>dp", function()
        dap.pause()
      end, { desc = "Step Pause" })

      vim.keymap.set("n", "<leader>dr", function()
        dap.repl.toggle({ height = 7 }, "lefta split")
      end, { desc = "Step Repl toggle" })

      vim.keymap.set("n", "<leader>dq", function()
        dap.close()
      end, { desc = "Quit" })

      vim.keymap.set("n", "<leader>dU", function()
        require("dapui").toggle({ reset = true })
      end, { desc = "Toggle UI" })
    end

    local setup_icons = function()
      local sign = vim.fn.sign_define
      local icons = require("configs.icons").ui
      sign("DapBreakpoint", {
        text = icons.Point,
        numhl = "DapBreakpoint",
        texthl = "DapBreakpoint",
      })

      sign("DapBreakpointCondition", {
        text = icons.Point,
        numhl = "DapBreakpointCondition",
        texthl = "DapBreakpointCondition",
      })

      sign("DagLogPoint", {
        text = icons.Unchecked,
        numhl = "DapLogPoint",
        texthl = "DapLogPoint",
      })

      sign("DapStopped", {
        text = icons.Stopped,
        numhl = "DapStopped",
        texthl = "DapStopped",
      })

      sign("DapBreakpointRejected", {
        text = icons.Rejected,
        numhl = "DapBreakpointRejected",
        texthl = "DapBreakpointRejected",
      })
    end

    local function init_adapters()
      local dap = require("dap")
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
    end

    local function init_languages()
      local dap = require("dap")
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
    end

    init_dap()

    setup_keymaps()
    setup_icons()

    init_adapters()
    init_languages()
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
