local settings = {
  vtsls = {
    autoUseWorkspaceTsdk = true,
  },
  javascript = {
    inlayHints = {
      parameterNames = { enabled = "all" },
      parameterTypes = { enabled = true },
      variableTypes = { enabled = true },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = true },
      enumMemberValues = { enabled = true },
    },
  },
  typescript = {
    tsserver = {
      experimental = {
        enableProjectDiagnostics = true,
      },
    },
    inlayHints = {
      parameterNames = { enabled = "all" },
      parameterTypes = { enabled = true },
      variableTypes = { enabled = true },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = true },
      enumMemberValues = { enabled = true },
    },
  },
}

---@type vim.lsp.Config
return {
  handlers = {
    ["textDocument/publishDiagnostics"] = function(err, result, ctx)
      if result and result.diagnostics then
        for _, diagnostic in ipairs(result.diagnostics) do
          if diagnostic.code == 6133 then
            diagnostic.severity = 4
          end
        end
      end
      vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
    end,
  },
  settings = settings,
}
