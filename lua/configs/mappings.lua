local os = require("utils").detect_os()

-------------------------------------------------------------------------------
---[[general]]

-- quickly motion
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move left" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move right" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move up" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })

-- remap start of line
vim.keymap.set("c", "<C-a>", "<C-b>", { desc = "Move beginning of line", remap = true })

-- esc clear highlights
vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })

-- quit window
-- vim.keymap.set("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>q", function()
  if vim.bo.ft == "TelescopePrompt" then
    vim.cmd("q!")
  elseif vim.bo.ft == "checkhealth" then
    vim.cmd("bd")
  else
    vim.cmd("confirm q")
  end
end, { desc = "Quit" })

-- easy paste
local paste_map = os == "macos" and "<M-v>" or "<C-v>"
if vim.g.neovide then
  paste_map = "<D-v>"
end

vim.keymap.set(
  { "i", "t" },
  paste_map,
  "<esc>:set paste<cr>a<c-r>=getreg('+')<cr><esc>:set nopaste<cr>mi`[=`]`ia",
  { desc = "Paste insert-mode" }
)
vim.keymap.set("c", paste_map, "<C-r>+", { desc = "Paste cmd-mode" })

-- open uri
local open_uri_cmds = {
  macos = '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>',
  windows = '<Cmd>call jobstart(["start", expand("<cfile>")], {"detach": v:true})<CR>',
  wsl = '<Cmd>call jobstart(["start", expand("<cfile>")], {"detach": v:true})<CR>',
  linux = '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>',
}

local open_uri_cmd = open_uri_cmds[os]
vim.keymap.set("n", "gx", open_uri_cmd, { desc = "Opening URI" })

-- save
vim.keymap.set("n", "<leader>w", "<cmd>w!<CR>", { desc = "Save with formatting" })
vim.keymap.set("n", "<leader>W", "<cmd>noautocmd w<CR>", { desc = "Save without formatting" })

-- indent when visual block
vim.keymap.set("v", "<", "<gv", { desc = "Indent line backward" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent line forward" })

-- quickfix toggle
vim.keymap.set("n", "<C-q>", function()
  require("utils").quickfix_toggle()
end, { desc = "Toggle quickfix window" })

-- loclist toggle
vim.keymap.set("n", "<C-Tab>", function()
  require("utils").loclist_toggle()
end, { desc = "Toggle loclist window" })

-------------------------------------------------------------------------------
---[[Lsp]]
vim.keymap.set("n", "<leader>lm", function()
  vim.lsp.buf.format()
end, { desc = "Format synchronous" })

vim.keymap.set("n", "<leader>lM", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format asynchronous" })

vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Reference" })

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })

vim.keymap.set("n", "gF", vim.lsp.buf.type_definition, { desc = "Type definition" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover information" })

vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })

vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "Signature" })

vim.keymap.set("n", "gR", vim.lsp.buf.rename, { desc = "Lsp Rename" })

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
  vim.diagnostic.goto_prev({ float = true })
end, { desc = "Prev diagnostic" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.goto_next({ float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "<leader>lk", function()
  vim.diagnostic.goto_prev({ float = true })
end, { desc = "Prev diagnostic" })

vim.keymap.set("n", "<leader>lj", function()
  vim.diagnostic.goto_next({ float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix" })

vim.keymap.set("n", "<leader>ll", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
