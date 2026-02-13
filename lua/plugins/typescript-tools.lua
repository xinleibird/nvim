local M = {
  "pmizio/typescript-tools.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "dmmulroy/ts-error-translator.nvim",
      config = function()
        require("ts-error-translator").setup({
          auto_attach = true,
          servers = {
            "astro",
            "svelte",
            "ts_ls",
            "typescript-tools",
            "volar",
            "vtsls",
          },
        })
      end,
    },
  },
  opts = {
    settings = {
      tsserver_file_preferences = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      },
    },
  },
}

return M
