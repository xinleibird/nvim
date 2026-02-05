return {
  diff = function()
    local replacement = vim.system({ "git", "-P", "diff", "--no-ext-diff", "--staged" }, { text = true }):wait().stdout
    local safe_replacement = replacement ~= nil and replacement:gsub("%%", "%%%%") or ""
    safe_replacement = safe_replacement:gsub("!?%[([^%]]*)%]%([^%)]*%)", " FilteredLink! ")
    safe_replacement = safe_replacement:gsub("(https?|ftp)://[%w-_%.~:/?#\\[\\]@!$&'()*+,;=]+", " FILTERED_URL ")

    return safe_replacement
  end,
}
