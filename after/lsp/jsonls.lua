---@type vim.lsp.Config
return {
  single_file_support = true,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas({
        select = {
          ".eslintrc",
          "lerna.json",
          "package.json",
          "prettierrc.json",
          "tsconfig.json",
          "tslint.json",
        },
        replace = {
          ["tsconfig.json"] = {
            description = "Custom JSON schema for typescript configuration files",
            fileMatch = { "tsconfig*.json" },
            name = "tsconfig.json",
            url = "https://json.schemastore.org/tsconfig.json",
          },
        },
      }),
      validate = { enable = true },
    },
  },
}
