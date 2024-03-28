local M = {
  "dmmulroy/tsc.nvim",
  event = "BufRead",
  config = function()
    local utils = require("tsc.utils")
    local function find_nearest_jsconfig()
      local jsconfig = vim.fn.findfile("jsconfig.json", ".;")

      if jsconfig ~= "" then
        return jsconfig
      end

      return nil
    end

    require("tsc").setup({
      auto_open_qflist = false,
      auto_close_qflist = false,
      auto_focus_qflist = false,
      auto_start_watch_mode = false,
      use_trouble_qflist = false,
      bin_path = utils.find_tsc_bin(),
      enable_progress_notifications = true,
      flags = {
        noEmit = true,
        project = function()
          local tsconfig = utils.find_nearest_tsconfig()
          if tsconfig then
            return tsconfig
          end

          return find_nearest_jsconfig()
        end,
        watch = false,
      },
      hide_progress_notifications_from_history = true,
      spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
      pretty_errors = true,
    })
  end,
}

return M
