---@type vim.lsp.Config
return {
  ---@module "lspconfig"
  ---@type lspconfig.settings.lua_ls
  settings = {
    Lua = {
      diagnostics = {
        neededFileStatus = {
          ["assign-type-mismatch"] = "Any",
          ["await-in-sync"] = "Any",
          ["cast-local-type"] = "Any",
          ["cast-type-mismatch"] = "Any",
          ["code-after-break"] = "Any",
          ["duplicate-set-field"] = "Any",
          ["empty-block"] = "Any",
          ["inject-field"] = "Any",
          ["need-check-nil"] = "Any",
          ["param-type-mismatch"] = "Any",
          ["redefined-local"] = "Any",
          ["redundant-return"] = "Any",
          ["return-type-mismatch"] = "Any",
          ["trailing-space"] = "Any",
          ["undefined-field"] = "Any",
          ["unreachable-code"] = "Any",
          ["unused-function"] = "Any",
          ["unused-label"] = "Any",
          ["unused-local"] = "Any",
          ["unused-vararg"] = "Any",
        },
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}
