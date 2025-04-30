local settings = {}
for _, lang in ipairs({
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
}) do
  settings[lang] = {
    inlayHints = {
      parameterNames = { enabled = "all" },
      parameterTypes = { enabled = true },
      variableTypes = { enabled = true },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = true },
      enumMemberValues = { enabled = true },
    },
  }
end

return {
  cmd = { "vtsls", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "jsconfig.json", "tsconfig.json", "package.json", ".git" },
  single_file_support = true,

  settings = settings,
}
