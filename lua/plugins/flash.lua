local M = {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    search = {
      exclude = {
        "notify",
        "cmp_menu",
        "noice",
        "flash_prompt",
        "alpha",
        "snacks_dashboard",
        function(win)
          -- exclude non-focusable windows
          return not vim.api.nvim_win_get_config(win).focusable
        end,
      },
    },
    modes = {
      char = {
        config = function(opts)
          -- autohide flash when in operator-pending mode
          opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
          opts.multi_line = opts.multi_line and not vim.fn.mode(true):find("o")

          opts.jump_labels = opts.jump_labels
            and not vim.fn.mode(true):find("o") -- hide jump_labels in operator pending mode
            and vim.v.count == 0
            and vim.fn.reg_executing() == ""
            and vim.fn.reg_recording() == ""
        end,
        autohide = true,
        search = { wrap = false },
        multi_line = false,
        jump_labels = true,
        keys = { "f", "F", "t", "T" },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}

return M
