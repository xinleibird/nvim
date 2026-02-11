local M = {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = 20,
    open_mapping = "<Nop>",
    hide_numbers = true,
    shade_terminals = false,
    start_in_insert = true,
    persist_size = true,
    direction = "horizontal",
    close_on_exit = true,
    on_open = function()
      vim.wo.cursorline = false
      vim.wo.cursorcolumn = false
      vim.wo.number = false
      vim.wo.relativenumber = false
    end,
  },
  dependencies = {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      bottom = {
        {
          ft = "toggleterm",
          title = " term %{b:toggle_number}",
          size = { height = 0.4 },
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
          wo = {
            winhighlight = "Normal:Normal,NormalNC:NormalNC",
          },
        },
      },
    },

    init = function()
      local decorate = "M"
      if vim.g.neovide then
        decorate = "D"
      end
      if vim.env.TERM and (vim.env.TERM == "xterm-kitty" or vim.env.TERM == "xterm-ghostty") then
        decorate = "D"
      end
      vim.keymap.set({ "n", "t" }, "<" .. decorate .. "-S-j>", function()
        local terms = require("toggleterm.terminal").get_all()
        local new_id = #terms + 1
        vim.cmd(new_id .. "ToggleTerm direction=horizontal")
      end, { desc = "New Terminal Instance" })

      vim.keymap.set({ "n", "t" }, "<" .. decorate .. "-j>", function()
        local terms = require("toggleterm.terminal").get_all()
        if #terms == 0 then
          local new_id = #terms + 1
          vim.cmd(new_id .. "ToggleTerm direction=horizontal")
        else
          require("toggleterm").toggle_all()
        end
      end, { desc = "Toggle All Terminals" })
    end,
  },
}

return M
