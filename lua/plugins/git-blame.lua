local M = {
  "f-person/git-blame.nvim",
  -- load the plugin at startup
  event = "BufRead",
  keys = {
    {
      "gm",
      "<cmd>GitBlameToggle<cr>",
      desc = "Toggle blame",
    },
  },
  opts = {
    enabled = false, -- if you want to enable the plugin
    message_template = " 「<summary>」• <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
    date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
    virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
  },
}

return M
