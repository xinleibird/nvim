---@module "lazy"
---@type LazySpec
local M = {
  "rcarriga/nvim-dap-ui",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  dependencies = {
    {
      "mfussenegger/nvim-dap",
      config = function()
        local files_str = vim.fn.glob(vim.fn.stdpath("config") .. "/dap/*.lua")
        local files_list = vim.split(files_str, "\n", { plain = true })
        for _, file_path in ipairs(files_list) do
          dofile(file_path)
        end

        local dap = require("dap")
        vim.keymap.set("n", "<leader>dt", function()
          dap.toggle_breakpoint()
        end, { desc = "DAP: Toggle Breakpoints" })
        vim.keymap.set("n", "<F9>", function()
          dap.toggle_breakpoint()
        end, { desc = "DAP: Toggle Breakpoints" })

        vim.keymap.set("n", "<leader>dc", function()
          dap.set_breakpoint(vim.fn.input("Breakpoint Condition: "))
        end, { desc = "DAP: Set Conditional Breakpoint" })
        vim.keymap.set("n", "<S-F9>", function()
          dap.set_breakpoint(vim.fn.input("Breakpoint Condition: "))
        end, { desc = "DAP: Set Conditional Breakpoint" })
        vim.keymap.set("n", "<F21>", function() -- <S-F9>
          dap.set_breakpoint(vim.fn.input("Breakpoint Condition: "))
        end, { desc = "DAP: Set Conditional Breakpoint" })

        vim.keymap.set("n", "<leader>ds", function()
          dap.continue()
        end, { desc = "DAP: Start/Continue" })
        vim.keymap.set("n", "<F5>", function()
          dap.continue()
        end, { desc = "DAP: Start/Continue" })

        vim.keymap.set("n", "<leader>do", function()
          dap.step_over()
        end, { desc = "DAP: Step Over" })
        vim.keymap.set("n", "<F10>", function()
          dap.step_over()
        end, { desc = "DAP: Step Over" })

        vim.keymap.set("n", "<leader>di", function()
          dap.step_into()
        end, { desc = "DAP: Step Into" })
        vim.keymap.set("n", "<F11>", function()
          dap.step_into()
        end, { desc = "DAP: Step Into" })

        vim.keymap.set("n", "<leader>du", function()
          dap.step_out()
        end, { desc = "DAP: Step Out" })
        vim.keymap.set("n", "<S-F11>", function()
          dap.step_out()
        end, { desc = "DAP: Step Out" })
        vim.keymap.set("n", "<F23>", function() -- <S-F11>
          dap.step_out()
        end, { desc = "DAP: Step Out" })

        vim.keymap.set("n", "<leader>dd", function()
          dap.terminate()
        end, { desc = "DAP: Stop" })
        vim.keymap.set("n", "<S-F5>", function()
          dap.terminate()
        end, { desc = "DAP: Stop" })
        vim.keymap.set("n", "<F17>", function() -- <S-F5>
          dap.terminate()
        end, { desc = "DAP: Stop" })

        local icons = require("configs.icons")
        vim.fn.sign_define(
          "DapBreakpoint",
          { text = icons.ui.Point, numhl = "DapBreakpoint", texthl = "DapBreakpoint" }
        )
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
    },
    {
      "0xferrous/ansi.nvim",
      config = function()
        require("ansi").setup({
          auto_enable = true, -- Auto-enable for configured filetypes
          filetypes = { "log", "ansi", "dap-repl" }, -- Filetypes to auto-enable
          theme = "gruvbox",
        })
      end,
    },
    "nvim-neotest/nvim-nio",
  },
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
            { id = "scopes", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 0.2,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 0.25,
          position = "top",
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

    local dap = require("dap")
    local dapui = require("dapui")

    local function render_dap_repl_ansi()
      local repl_buf = nil
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == "dap-repl" then
          repl_buf = buf
          break
        end
      end

      if repl_buf then
        require("ansi.renderer").enable_for_buffer(repl_buf, "gruvbox")
      end
    end

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated.dapui_config = function()
      render_dap_repl_ansi()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      render_dap_repl_ansi()
    end

    -- dap.listeners.before.event_terminated.dapui_config = function()
    --   dapui.close()
    -- end
    -- dap.listeners.before.event_exited.dapui_config = function()
    --   dapui.close()
    -- end

    vim.keymap.set("n", "<leader>dU", function()
      dapui.toggle({ reset = true })
    end, { desc = "Toggle DAP UI" })
    vim.keymap.set("n", "<C-S-D>", function()
      dapui.toggle({ reset = true })
    end, { desc = "Toggle DAP UI" })

    vim.keymap.set("n", "<Esc>", function()
      vim.cmd("noh")
      vim.api.nvim_feedkeys("hl", "n", true)
      if vim.diagnostic.config().virtual_lines then
        vim.diagnostic.config({ virtual_lines = false })
      end
    end, { desc = "Clear highlights, Escape popup and virtual lines" })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "dap-*", "dapui_*" },
      callback = function()
        vim.keymap.set("n", "q", function()
          require("dapui").close()
        end, { buffer = true, silent = true, nowait = true })
        vim.keymap.set("n", "<leader>q", function()
          require("dapui").close()
        end, { buffer = true, silent = true, nowait = true })
      end,
    })
  end,
}

return M
