local M = {
  "ethanholz/nvim-lastplace",
  event = "BufRead",
  config = function()
    require("nvim-lastplace").setup({
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit", "nvcheatsheet", "nvdash" },
      lastplace_open_folds = true,
    })
  end,
}

return M
