local map = vim.keymap.set

local os = require("utils").detect_os()

local system_alt_key = os == "macos" and "M" or "A"
if vim.g.neovide then
  system_alt_key = "D"
end

-------------------------------------------------------------------------------
---[[general]]

-- quickly motion
map("i", "<C-h>", "<Left>", { desc = "Move Left" })
map("i", "<C-l>", "<Right>", { desc = "Move Right" })
map("i", "<C-j>", "<Down>", { desc = "Move Down" })
map("i", "<C-k>", "<Up>", { desc = "Move Up" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

-- remap start of line
map("i", "<C-a>", "<Home>", { desc = "Move begin of line" })
map("i", "<C-e>", "<End>", { desc = "Move end of line" })
map("c", "<C-a>", "<C-b>", { desc = "Move beginning of line", remap = true })

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
  "i",
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
map("n", "<leader>W", "<cmd>noautocmd w<CR>", { desc = "Save without formatting" })

-- indent when visual block
map("v", "<", "<gv", { desc = "Indent line forward" })
map("v", ">", ">gv", { desc = "Indent line backward" })

-- quickfix toggle
map("n", "<C-q>", function()
  require("utils").quickfix_toggle()
end, { desc = "Toggle quickfix" })

-- loclist toggle
map("n", "<C-Tab>", function()
  require("utils").loclist_toggle()
end, { desc = "Toggle loclist" })

-------------------------------------------------------------------------------
---[[bufferline]]
map("n", "<leader>c", function()
  require("utils").buf_kill("bd")
end, { desc = "Close current buffer" })

map("n", "<leader>be", "<cmd>enew<CR>", { desc = "New buffer" })

map("n", "<leader>bb", "<cmd>BufferLineCyclePrev<CR>", { desc = "Goto prev buffer" })

map("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", { desc = "Goto next buffer" })

map("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", { desc = "Goto prev buffer" })

map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close others buffers" })

map("n", "<leader>bh", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close left buffers" })

map("n", "<leader>bl", "<cmd>BufferLineCloseRight<CR>", { desc = "Close right buffers" })

-------------------------------------------------------------------------------
---[[Alpha toggle]]
map("n", "<leader>;", "<cmd>Alpha<CR>", { desc = "Toggle Alpha" })

-------------------------------------------------------------------------------
---[[ToggleTerm]]
map(
  { "n", "t" },
  "<" .. system_alt_key .. "-j>",
  "<cmd>ToggleTerm<CR>",
  { desc = "Terminal New horizontal term" }
)

map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

-------------------------------------------------------------------------------
---[[NvimTree]]
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

-------------------------------------------------------------------------------
---[[Lsp]]
map("n", "<leader>lm", function()
  vim.lsp.buf.format()
end, { desc = "Format buffer synchronous" })

map("n", "<leader>lM", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer asynchronous" })

map("n", "gr", vim.lsp.buf.references, { desc = "Lsp Show references" })

map("n", "gD", vim.lsp.buf.declaration, { desc = "Lsp Go to declaration" })

map("n", "gd", vim.lsp.buf.definition, { desc = "Lsp Go to definition" })

map("n", "gF", vim.lsp.buf.type_definition, { desc = "Lsp Go to type definition" })

map("n", "K", vim.lsp.buf.hover, { desc = "Lsp hover information" })

map("n", "gi", vim.lsp.buf.implementation, { desc = "Lsp Go to implementation" })

map("n", "gs", vim.lsp.buf.signature_help, { desc = "Lsp Show signature help" })

map("n", "gR", vim.lsp.buf.rename, { desc = "Lsp Rename" })

map("n", "<F2>", vim.lsp.buf.rename, { desc = "Lsp Rename" })

-- map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Lsp Add workspace folder" })
-- map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Lsp Remove workspace folder" })
-- map("n", "<leader>wl", function()
--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end, { desc = "Lsp List workspace folders" })

map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Lsp Code action" })

map("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Lsp floating diagnostics" })

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

map("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "Lsp all diagnostic quickfix" })

map("n", "<leader>le", vim.diagnostic.setloclist, { desc = "Lsp buf diagnostic loclist" })

map("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0 <CR>", { desc = "Lsp buf diagnostic Telescope" })

map("n", "<leader>lw", "<cmd>Telescope diagnostics<CR>", { desc = "Lsp workspace diagnostic Telescope" })

-------------------------------------------------------------------------------
---[[Comment]]

map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

map(
  "v",
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Toggle comment" }
)

-------------------------------------------------------------------------------
---[[Telescope]]
map("n", "<leader>sP", "<cmd>Telescope projects<CR>", { desc = "Search projects" })

map("n", "<leader>sp", "<cmd>Telescope find_files<cr>", { desc = "Search files" })

map(
  "n",
  "<leader>sa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "Search files contains ignored and hidden" }
)

map("n", "<leader>st", "<cmd>Telescope live_grep<CR>", { desc = "Search text" })

map("n", "<leader>sc", "<cmd>Telescope grep_string<CR>", { desc = "Search text under cursor" })

map("v", "<leader>sc", "<cmd>Telescope grep_string<CR>", { desc = "Search text visual selected" })

map("n", "<leader>sb", "<cmd>Telescope buffers<CR>", { desc = "Search buffers" })

map("n", "<leader>sh", "<cmd>Telescope help_tags<CR>", { desc = "Search Help page" })

map("n", "<leader>sr", "<cmd>Telescope oldfiles<CR>", { desc = "Search recnet oldfiles" })

map(
  "n",
  "<leader>sz",
  "<cmd>Telescope current_buffer_fuzzy_find<CR>",
  { desc = "Search current buffer fuzzy" }
)

-------------------------------------------------------------------------------
---[[Gitlazy]]
map("n", "<leader>gg", function()
  local ok, gitlazy = pcall(require, "gitlazy")
  if ok then
    gitlazy.open()
  end
end, { desc = "Open lazygit" })

-------------------------------------------------------------------------------
---[[GitSigns]]
map("n", "<leader>go", "<cmd>Telescope git_status<CR>", { desc = "Search changed files" })

map("n", "<leader>gj", function()
  require("gitsigns").next_hunk()
end, { desc = "Jump to next hunk", expr = true })

map("n", "<leader>gk", function()
  require("gitsigns").prev_hunk()
end, { desc = "Jump to prev hunk", expr = true })

map("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(function()
    require("gitsigns").next_hunk()
  end)
  return "<Ignore>"
end, { desc = "Jump to next hunk", expr = true })

map("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    require("gitsigns").prev_hunk()
  end)
  return "<Ignore>"
end, { desc = "Jump to prev hunk", expr = true })

map("n", "<leader>gb", function()
  package.loaded.gitsigns.blame_line()
end, { desc = "Blame line", expr = true })

map("n", "<leader>gd", function()
  require("gitsigns").diffthis("", { split = "belowright" })
end, { desc = "Diff this file", expr = true })

-------------------------------------------------------------------------------
---[[Outline]]
map("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
