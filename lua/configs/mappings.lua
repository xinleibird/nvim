-- quickly motion
vim.keymap.set({ "n", "t", "i" }, "<C-h>", "<cmd>wincmd h<CR>", { desc = "Jump left window" })
vim.keymap.set({ "n", "t", "i" }, "<C-l>", "<cmd>wincmd l<CR>", { desc = "Jump right window" })
vim.keymap.set({ "n", "t", "i" }, "<C-j>", "<cmd>wincmd j<CR>", { desc = "Jump down window" })
vim.keymap.set({ "n", "t", "i" }, "<C-k>", "<cmd>wincmd k<CR>", { desc = "Jump up window" })

-- alias record macro that "q" to "Q"
vim.keymap.set({ "n" }, "Q", "q", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "q", "<Nop>", { noremap = true, silent = true })

-- Ctrl+a: beginning of line in command mode (tty-style)
vim.keymap.set("c", "<C-a>", "<C-b>", { desc = "Move beginning of line" })

vim.keymap.set("i", "<C-a>", "<C-o>I", { desc = "Move beginning of line" })
vim.keymap.set("i", "<C-e>", "<C-o>A", { desc = "Move ending of line" })

local function close_float()
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(winid).relative ~= "" then
      local bufnr = vim.api.nvim_win_get_buf(winid)
      local filetype = vim.bo[bufnr].filetype
      if (filetype == "" or filetype == "markdown") and vim.bo[bufnr].buftype == "nofile" then
        vim.api.nvim_win_close(winid, true)
      end
    end
  end
end
-- esc clear highlights, Escape popup
vim.keymap.set("n", "<Esc>", function()
  vim.cmd("noh")
  close_float()
  if vim.diagnostic.config().virtual_lines then
    vim.diagnostic.config({ virtual_lines = false })
  end
end, { desc = "Clear highlights, Escape popup and virtual lines" })

-- stylua: ignore start
-- quit window
vim.keymap.set("n", "<leader>q", function() vim.cmd("confirm q") end, { desc = "Quit" })

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
-- stylua: ignore end
