--lsp config
local icons = require("configs.icons")
vim.diagnostic.config({
  -- virtual_text = {
  --   prefix = function(diagnostic)
  --     if diagnostic.severity == vim.diagnostic.severity.HINT then
  --       return icons.diagnostics.Hint
  --     end
  --     if diagnostic.severity == vim.diagnostic.severity.INFO then
  --       return icons.diagnostics.Info
  --     end
  --     if diagnostic.severity == vim.diagnostic.severity.WARN then
  --       return icons.diagnostics.Warn
  --     end
  --     if diagnostic.severity == vim.diagnostic.severity.ERROR then
  --       return icons.diagnostics.Error
  --     end
  --
  --     return ""
  --   end,
  --   source = true,
  -- },
  virtual_text = false,
  float = {
    source = true,
  },
  virtual_lines = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
    },
  },
  underline = true,
  update_in_insert = false,
})

local function toggle_virtual_lines()
  local state = vim.diagnostic.config().virtual_lines and { virtual_lines = false }
    or { virtual_lines = { current_line = true } }
  vim.diagnostic.config(state)
end
vim.keymap.set("n", "<leader>lv", toggle_virtual_lines, { desc = "Toggle diagnostics virtual" })
vim.keymap.set("n", "gv", toggle_virtual_lines, { desc = "Toggle diagnostics line" })

--stylua: ignore start
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
vim.keymap.set("n", "gF", vim.lsp.buf.type_definition, { desc = "Type definition" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
vim.keymap.set("n", "gI", vim.lsp.buf.incoming_calls, { desc = "Incoming calls" })
vim.keymap.set("n", "gO", vim.lsp.buf.outgoing_calls, { desc = "Outgoing calls" })
-- any config in https://github.com/MysticalDevil/inlay-hints.nvim
vim.keymap.set("n", "gh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 }) end, { desc = "Inlay hints" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover information" })
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Lsp Rename" })
vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })

vim.keymap.set("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Floating diagnostics" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Floating diagnostics" })

vim.keymap.set("n", "<leader>lm", function() vim.lsp.buf.format() end, { desc = "Format synchronous" })
vim.keymap.set("n", "<leader>lM", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format asynchronous" })

vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "Signature" })
vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, { desc = "Signature" })

vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>lk", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
vim.keymap.set("n", "<leader>lj", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })

-- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Lsp Add workspace folder" })
-- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Lsp Remove workspace folder" })
-- vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { desc = "Lsp List workspace folders" })
--stylua: ignore end

-- lsp config
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
})

-- lsp enable
vim.lsp.enable({
  "bashls",
  "cssls",
  "eslint",
  "emmet_language_server",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "rust_analyzer",
  "svelte",
  "tailwindcss",
  -- "ts_ls",
  "vimls",
  -- "vtsls",
  "vue_ls",
  "yamlls",
  -- "zk",
})
