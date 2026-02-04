local M = {
  "pmizio/typescript-tools.nvim",
  event = "BufEnter *.*",
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
            "tsserver", -- deprecated, use ts_ls
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
        includeInlayParameterNameHints = "all",
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      },
    },
  },
}

return M
