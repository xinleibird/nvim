-- quickly motion
vim.keymap.set({ "n", "t", "i" }, "<C-h>", "<cmd>wincmd h<CR>", { desc = "Jump left window" })
vim.keymap.set({ "n", "t", "i" }, "<C-l>", "<cmd>wincmd l<CR>", { desc = "Jump right window" })
vim.keymap.set({ "n", "t", "i" }, "<C-j>", "<cmd>wincmd j<CR>", { desc = "Jump down window" })
vim.keymap.set({ "n", "t", "i" }, "<C-k>", "<cmd>wincmd k<CR>", { desc = "Jump up window" })

-- alias record macro that "q" to "Q"
vim.keymap.set({ "n" }, "Q", "q", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "q", "<Nop>", { noremap = true, silent = true })

-- remap start of line
vim.keymap.set("c", "<C-a>", "<Home>", { desc = "Move beginning of line" })
vim.keymap.set("c", "<C-b>", "<End>", { desc = "Move ending of line" })

-- esc clear highlights, Escape popup
vim.keymap.set("n", "<Esc>", function()
  vim.cmd("noh")
  vim.api.nvim_feedkeys("hl", "nt", true)
  if vim.diagnostic.config().virtual_lines then
    vim.diagnostic.config({ virtual_lines = false })
  end
end, { desc = "Clear highlights, Escape popup and virtual lines" })

-- quit window
vim.keymap.set("n", "<leader>q", function()
  if vim.bo.ft == "checkhealth" or vim.bo.ft == "snacks_dashboard" then
    vim.cmd("q!")
  elseif vim.bo.ft == "qf" then
    vim.cmd("cclose")
  elseif vim.bo.ft == "NeogitStatus" or vim.bo.ft == "help" then
    vim.cmd("close")
  elseif
    vim.bo.ft == "dapui_scopes"
    or vim.bo.ft == "dap-repl"
    or vim.bo.ft == "dapui_console"
    or vim.bo.ft == "dapui_watches"
    or vim.bo.ft == "dapui_stacks"
    or vim.bo.ft == "dapui_breakpoints"
  then
    require("dapui").close()
  else
    vim.cmd("confirm q")
  end
end, { desc = "Quit" })

--stylua: ignore start
-- easy paste
local current_os = require("utils").detect_os()
local paste_map = current_os == "macos" and "<M-v>" or "<C-v>"
if vim.g.neovide then
  paste_map = "<D-v>"
end
if vim.env.TERM and (vim.env.TERM == "xterm-kitty" or vim.env.TERM == "xterm-ghostty") then
  paste_map = "<D-v>"
end
vim.keymap.set(
  { "i", "n" },
  paste_map,
  "<esc>:set paste<cr>a<c-r>=getreg('+')<cr><esc>:set nopaste<cr>mi`[=`]`ia",
  { desc = "Paste insert-mode" }
)
vim.keymap.set("c", paste_map, "<C-r>+", { desc = "Paste" })

-- save
vim.keymap.set("n", "<leader>w", "<cmd>w!<CR>", { desc = "Save with formatting" })
vim.keymap.set("n", "<leader>W", "<cmd>noautocmd w<CR>", { desc = "Save without formatting" })

-- indent when visual block
vim.keymap.set("v", "<", "<gv", { desc = "Indent line backward" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent line forward" })

-- quickfix loclist
vim.keymap.set("n", "<C-q>", function() require("utils").quickfix_toggle() end, { desc = "Toggle quickfix window" })
vim.keymap.set("n", "<C-`>", function() require("utils").loclist_toggle() end, { desc = "Toggle loclist window" })


vim.keymap.set({ "i", "s" }, "<Esc>", function() vim.snippet.stop() return "<Esc>" end, { expr = true })
vim.keymap.set({ "i", "s" }, "<C-c>", function() vim.snippet.stop() return "<C-c>" end, { expr = true })
--stylua: ignore end

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("user_toggle_wincmd_keymap_for_codecompanion_float_window", { clear = true }),
  callback = function()
    local win_config = vim.api.nvim_win_get_config(0)
    if win_config.relative ~= "" and vim.bo[0].filetype ~= "snacks_picker_list" then
      vim.keymap.set({ "n", "t", "i" }, "<C-h>", "<Nop>", { silent = true, buffer = true })
      vim.keymap.set({ "n", "t", "i" }, "<C-l>", "<Nop>", { silent = true, buffer = true })
      vim.keymap.set({ "n", "t", "i" }, "<C-j>", "<Nop>", { silent = true, buffer = true })
      vim.keymap.set({ "n", "t", "i" }, "<C-k>", "<Nop>", { silent = true, buffer = true })
    end
  end,
})

local hotkey_group = vim.api.nvim_create_augroup("user_buf_quit_q_hotkey", { clear = true })
-- Close window with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf", "help" },
  group = hotkey_group,
  command = "nnoremap <buffer><silent> q <cmd>close!<CR>",
})
-- Close window with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "dapui_scopes",
    "dap-repl",
    "dapui_console",
    "dapui_watches",
    "dapui_stacks",
    "dapui_breakpoints",
  },
  group = hotkey_group,
  command = "nnoremap <buffer><silent> q <cmd>lua require('dapui').close()<CR>",
})
-- Close checkhealth buffer with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "checkhealth" },
  group = hotkey_group,
  command = "nnoremap <buffer><silent> q <cmd>bd<CR>|nnoremap <buffer><silent> <C-w>q <cmd>bd<CR>",
})

-- Close buffer with Esc
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf", "lazy" },
  group = hotkey_group,
  command = "nnoremap <buffer><silent> <Esc> <cmd>close!<CR>",
})
