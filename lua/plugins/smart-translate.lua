local M = {
  "askfiy/smart-translate.nvim",
  cmd = { "Translate" },
  dependencies = {
    "askfiy/http.nvim", -- a wrapper implementation of the Python aiohttp library that uses CURL to send requests.
  },
  opts = {
    default = {
      cmds = {
        source = "auto",
        target = "zh-CN",
        handle = "float",
        engine = "google",
      },
      cache = true,
    },
  },
}

return M
