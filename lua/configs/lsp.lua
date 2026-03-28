--lsp config
local icons = require("configs.icons")
---@type vim.diagnostic.Opts
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
    border = "rounded",
    source = "if_many",
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
  update_in_insert = true,
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
vim.keymap.set("n", "K", function () vim.lsp.buf.hover({border = "rounded"}) end, { desc = "Hover information" })
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Lsp Rename" })
vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })

vim.keymap.set("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Floating diagnostics" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Floating diagnostics" })

vim.keymap.set("n", "<leader>lm", function() vim.lsp.buf.format() end, { desc = "Format synchronous" })
vim.keymap.set("n", "<leader>lM", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format asynchronous" })

vim.keymap.set("n", "gs", function () vim.lsp.buf.signature_help({border = "rounded"}) end, { desc = "Signature" })
vim.keymap.set("n", "<leader>ls", function () vim.lsp.buf.signature_help({border = "rounded"}) end, { desc = "Signature" })
vim.keymap.set("i", "<C-s>", function () vim.lsp.buf.signature_help({border = "rounded"}) end, { desc = "Signature" })

vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>lk", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
vim.keymap.set("n", "<leader>lj", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })

vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>", { desc = "Restart LSP" })
--stylua: ignore end

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("user_lsp_progress_notify", { clear = true }),
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("󰍹 %s[%4d%%]%6s"):format(
            value.title or "",
            value.kind == "end" and 100 or value.percentage or 100,
            value.message and (" %s"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and ""
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

-- lsp enable
vim.lsp.enable({
  "bashls",
  "cssls",
  "emmet_language_server",
  "eslint",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "oxlint",
  "rust_analyzer",
  "svelte",
  "tailwindcss",
  "vimls",
  "vtsls",
  "vue_ls",
  "yamlls",
  -- "zk",
})
