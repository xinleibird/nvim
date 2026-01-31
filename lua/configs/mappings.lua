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
  vim.diagnostic.config({ virtual_lines = false })
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
