---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "snacks.nvim", words = { "Snacks" } },
        },
      },
    },
  },
}
