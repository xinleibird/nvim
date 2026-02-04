return {
  diff = function()
    local replacement = vim.system({ "git", "-P", "diff", "--no-ext-diff", "--staged" }, { text = true }):wait().stdout
    local safe_replacement = replacement ~= nil and replacement:gsub("%%", "%%%%") or ""
    return safe_replacement
  end,
}
