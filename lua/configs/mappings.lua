local map = vim.keymap.set

local os = require("utils").detect_os()

-------------------------------------------------------------------------------
---[[general]]

-- quickly motion
map("i", "<C-h>", "<Left>", { desc = "Move Left" })
map("i", "<C-l>", "<Right>", { desc = "Move Right" })
map("i", "<C-j>", "<Down>", { desc = "Move Down" })
map("i", "<C-k>", "<Up>", { desc = "Move Up" })

map("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window Right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window Up" })

-- remap start of line
map("c", "<C-a>", "<C-b>", { desc = "Move Beginning of line", remap = true })

-- esc clear highlights
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })

-- quite window
-- map("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "Quite" })
map("n", "<leader>q", function()
  if vim.bo.ft == "TelescopePrompt" then
    vim.cmd("q!")
  else
    vim.cmd("confirm q")
  end
end, { desc = "Quite" })

-- easy paste
local paste_map = os == "macos" and "<M-v>" or "<C-v>"
if vim.g.neovide then
  paste_map = "<D-v>"
end

map(
  { "i", "t" },
  paste_map,
  "<esc>:set paste<cr>a<c-r>=getreg('+')<cr><esc>:set nopaste<cr>mi`[=`]`ia",
  { desc = "Paste in INSERT mode" }
)
map("c", paste_map, "<C-r>+", { desc = "Paste in CMD mode" })

-- open uri
local open_uri_cmds = {
  macos = '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>',
  windows = '<Cmd>call jobstart(["start", expand("<cfile>")], {"detach": v:true})<CR>',
  wsl = '<Cmd>call jobstart(["start", expand("<cfile>")], {"detach": v:true})<CR>',
  linux = '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>',
}

local open_uri_cmd = open_uri_cmds[os]
map("n", "gx", open_uri_cmd, { desc = "Opening URI with system settings" })

-- save
map("n", "<leader>w", "<cmd>w!<CR>", { desc = "Save" })
map("n", "<leader>W", "<cmd>noautocmd w<CR>", { desc = "Save WITHOUT formatting" })

-- indent when visual block
map("v", "<", "<gv", { desc = "Indent line forward" })
map("v", ">", ">gv", { desc = "Indent line backward" })

-- -- quickfix toggle
-- map("n", "<C-q>", function()
--   require("utils").quickfix_toggle()
-- end, { desc = "Toggle quickfix" })
--
-- -- loclist toggle
-- map("n", "<C-Tab>", function()
--   require("utils").loclist_toggle()
-- end, { desc = "Toggle loclist" })

-------------------------------------------------------------------------------
---[[Lsp]]
map("n", "<leader>lm", function()
  vim.lsp.buf.format()
end, { desc = "Format buffer synchronous" })

map("n", "<leader>lM", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer asynchronous" })

map("n", "gr", vim.lsp.buf.references, { desc = "Lsp Go to References" })

map("n", "gD", vim.lsp.buf.declaration, { desc = "Lsp Go to Declaration" })

map("n", "gd", vim.lsp.buf.definition, { desc = "Lsp Go to Definition" })

map("n", "gF", vim.lsp.buf.type_definition, { desc = "Lsp go to type deFinition" })

map("n", "K", vim.lsp.buf.hover, { desc = "Lsp hover information" })

map("n", "gi", vim.lsp.buf.implementation, { desc = "Lsp Go to Implementation" })

map("n", "gs", vim.lsp.buf.signature_help, { desc = "Lsp Go to Signature help" })

map("n", "gR", vim.lsp.buf.rename, { desc = "Lsp Rename" })

map("n", "gl", vim.diagnostic.open_float, { desc = "Lsp Floating diagnostics" })

map("n", "<F2>", vim.lsp.buf.rename, { desc = "Lsp Rename" })

-- map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Lsp Add workspace folder" })
-- map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Lsp Remove workspace folder" })
-- map("n", "<leader>wl", function()
--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end, { desc = "Lsp List workspace folders" })

map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Lsp Code action" })

map("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Lsp Floating diagnostics" })

map("n", "[d", function()
  vim.diagnostic.goto_prev({ float = true })
end, { desc = "Lsp prev diagnostic" })

map("n", "]d", function()
  vim.diagnostic.goto_next({ float = true })
end, { desc = "Lsp next diagnostic" })

map("n", "<leader>lk", function()
  vim.diagnostic.goto_prev({ float = true })
end, { desc = "Lsp prev diagnostic" })

map("n", "<leader>lj", function()
  vim.diagnostic.goto_next({ float = true })
end, { desc = "Lsp next diagnostic" })

map("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "Lsp all diagnostic Quickfix" })

map("n", "<leader>le", vim.diagnostic.setloclist, { desc = "Lsp buf diagnostic Loclist" })
