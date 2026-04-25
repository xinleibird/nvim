---@module "lspconfig"
---@type lspconfig.settings.ts_ls
local settings = {
  typescript = {
    inlayHints = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
    tsserver = {
      experimental = {
        enableProjectDiagnostics = true,
      },
    },
  },
}

---@type vim.lsp.Config
return {
  settings = settings,
}
