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
    preferences = {
      useAliasesForRenames = false,
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
    preferences = {
      useAliasesForRenames = false,
    },
  },
}

---@type vim.lsp.Config
return {
  handlers = {
    ["textDocument/publishDiagnostics"] = function(err, result, ctx)
      if result and result.diagnostics then
        -- for _, diagnostic in ipairs(result.diagnostics) do
        --   if diagnostic.code == 6133 then
        --     diagnostic.severity = 4
        --   end
        -- end
        result.diagnostics = vim.tbl_filter(function()
          return not string.find(result.uri, "node_modules")
        end, result.diagnostics)
      end
      vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
    end,
  },
  settings = settings,
  on_attach = function(client, bufnr)
    client.commands["_typescript.didOrganizeImports"] = function() end

    vim.api.nvim_buf_create_user_command(bufnr, "OrganizeImports", function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
      })
    end, { desc = "Organize imports" })

    vim.api.nvim_buf_create_user_command(bufnr, "LspActions", function()
      local source_actions = vim.tbl_filter(function(action)
        return vim.startswith(action, "source.")
      end, client.server_capabilities.codeActionProvider.codeActionKinds)

      vim.lsp.buf.code_action({
        context = {
          only = source_actions,
          diagnostics = {},
        },
      })
    end, { desc = "Lsp Acctions from TypeScript" })
  end,
}
