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
