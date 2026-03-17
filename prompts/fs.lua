return {
  path = function()
    return vim.fn.expand("%:p")
  end,
  fpath = function()
    return vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
  end,
}
