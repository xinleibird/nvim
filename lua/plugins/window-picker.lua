local M = {
  "s1n7ax/nvim-window-picker",
  event = "UIEnter",
  init = function()
    local picker = require("window-picker")
    vim.keymap.set("n", ",", function()
      local picked_window_id = picker.pick_window({}) or vim.api.nvim_get_current_win()
      vim.api.nvim_set_current_win(picked_window_id)
    end, { desc = "Pick a window" })
  end,
  config = function()
    require("window-picker").setup({
      filter_rules = {
        autoselect_one = true,
        include_current_win = true,
        bo = {
          filetype = { "neo-tree-popup", "notify", "quickfix" },
          buftype = { "terminal" },
        },
      },
    })
  end,
}

return M
