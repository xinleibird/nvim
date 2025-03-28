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
        function(win)
          -- exclude non-focusable windows
          return not vim.api.nvim_win_get_config(win).focusable
        end,
      },
    },
    modes = {
      char = {
        enabled = true,
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
