---@type vim.lsp.Config
return {
  handlers = {
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
