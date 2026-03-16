---@type vim.lsp.Config
return {
  handlers = {
    ["eslint/openDoc"] = function(_, result)
      if result then
        vim.ui.open(result.url)
      end
      return {}
    end,
    ["eslint/confirmESLintExecution"] = function(_, result)
      if not result then
        return
      end
      return 4 -- approved
    end,
    ["eslint/probeFailed"] = function()
      vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
      return {}
    end,
    ["textDocument/diagnostic"] = function(err, result, ctx, config)
      if result and result.items then
        for _, item in ipairs(result.items) do
          if item.code == "@typescript-eslint/no-unused-vars" then
            item.severity = 4
            item.tags = { 1 }
          end
          if item.code == "no-unused-vars" then
            item.severity = 4
            item.tags = { 1 }
          end
        end
      end
      vim.lsp.handlers["textDocument/diagnostic"](err, result, ctx, config)
    end,
  },
}
