local os = require("utils").detect_os()
local trouble_loaded = pcall(require, "trouble")

-------------------------------------------------------------------------------
---[[general]]

-- quickly motion
vim.keymap.set({ "n", "t", "i" }, "<C-h>", "<cmd>wincmd h<CR>", { desc = "Jump left window" })
vim.keymap.set({ "n", "t", "i" }, "<C-l>", "<cmd>wincmd l<CR>", { desc = "Jump right window" })
vim.keymap.set({ "n", "t", "i" }, "<C-j>", "<cmd>wincmd j<CR>", { desc = "Jump down window" })
vim.keymap.set({ "n", "t", "i" }, "<C-k>", "<cmd>wincmd k<CR>", { desc = "Jump up window" })

-- remap start of line
vim.keymap.set("c", "<C-a>", "<Home>", { desc = "Move beginning of line" })
vim.keymap.set("c", "<C-b>", "<End>", { desc = "Move beginning of line" })

-- esc clear highlights
vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })

-- quit window
vim.keymap.set("n", "<leader>q", function()
  if vim.bo.ft == "TelescopePrompt" then
    vim.cmd("q!")
  elseif vim.bo.ft == "checkhealth" or vim.bo.ft == "snacks_dashboard" then
    vim.cmd("bd!")
  elseif vim.bo.ft == "qf" then
    vim.cmd("cclose")
  elseif vim.bo.ft == "NeogitStatus" then
    vim.cmd("close")
  else
    vim.cmd("confirm q")
    vim.cmd("silent! DiffviewClose")
  end
end, { desc = "Quit" })

-- easy paste
local paste_map = os == "macos" and "<M-v>" or "<C-v>"
if vim.g.neovide then
  paste_map = "<D-v>"
end

vim.keymap.set(
  { "i" },
  paste_map,
  "<esc>:set paste<cr>a<c-r>=getreg('+')<cr><esc>:set nopaste<cr>mi`[=`]`ia",
  { desc = "Paste insert-mode" }
)
vim.keymap.set("c", paste_map, "<C-r>+", { desc = "Paste cmd-mode" })

-- open uri
local success, _ = pcall(require, "open")
if not success then
  local open_uri_cmds = {
    macos = '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>',
    windows = '<Cmd>call jobstart(["start", expand("<cfile>")], {"detach": v:true})<CR>',
    wsl = '<Cmd>call jobstart(["start", expand("<cfile>")], {"detach": v:true})<CR>',
    linux = '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>',
  }

  local open_uri_cmd = open_uri_cmds[os]
  vim.keymap.set("n", "gx", open_uri_cmd, { desc = "Opening URI" })
end

-- save
vim.keymap.set("n", "<leader>w", "<cmd>w!<CR>", { desc = "Save with formatting" })
vim.keymap.set("n", "<leader>W", "<cmd>noautocmd w<CR>", { desc = "Save without formatting" })

-- indent when visual block
vim.keymap.set("v", "<", "<gv", { desc = "Indent line backward" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent line forward" })

if not trouble_loaded then
  -- quickfix toggle
  vim.keymap.set("n", "<C-q>", function()
    require("utils").quickfix_toggle()
  end, { desc = "Toggle quickfix window" })
  -- loclist toggle
  vim.keymap.set("n", "<C-Tab>", function()
    require("utils").loclist_toggle()
  end, { desc = "Toggle loclist window" })
end

-------------------------------------------------------------------------------
---[[Lsp]]
vim.keymap.set("n", "<leader>lm", function()
  vim.lsp.buf.format()
end, { desc = "Format synchronous" })

vim.keymap.set("n", "<leader>lM", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format asynchronous" })

if not trouble_loaded then
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })
  vim.keymap.set("n", "gF", vim.lsp.buf.type_definition, { desc = "Type definition" })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
end

vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "Signature" })
vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, { desc = "Signature" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover information" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Floating diagnostics" })
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Lsp Rename" })

-- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Lsp Add workspace folder" })
-- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Lsp Remove workspace folder" })
-- vim.keymap.set("n", "<leader>wl", function()
--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end, { desc = "Lsp List workspace folders" })

vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Floating diagnostics" })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>lk", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })
vim.keymap.set("n", "<leader>lj", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
