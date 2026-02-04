return {
  diff = function(args)
    return vim.system({ "git", "-P", "diff", "--no-ext-diff", "--staged" }, { text = true }):wait().stdout
  end,
}
