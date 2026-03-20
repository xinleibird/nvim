---@module "lazy"
---@type LazySpec
local M = {
  "akinsho/toggleterm.nvim",
  opts = {
    size = 20,
    open_mapping = "<Nop>",
    hide_numbers = true,
    shade_terminals = false,
    start_in_insert = true,
    persist_size = true,
    direction = "horizontal",
    close_on_exit = true,
    on_open = function()
      vim.wo.cursorline = false
      vim.wo.cursorcolumn = false
      vim.wo.number = false
      vim.wo.relativenumber = false
    end,
  },
  init = function()
    local decorate = "M"
    if vim.g.neovide then
      decorate = "D"
    end
    if vim.env.TERM and (vim.env.TERM == "xterm-kitty" or vim.env.TERM == "xterm-ghostty") then
      decorate = "D"
    end
    vim.keymap.set({ "n", "t" }, "<" .. decorate .. "-S-j>", function()
      if vim.bo.filetype == "snacks_picker_list" then
        vim.cmd("wincmd p")
      end

      local terms = require("toggleterm.terminal").get_all()
      local new_id = #terms + 1
      vim.cmd(new_id .. "ToggleTerm direction=horizontal")
    end, { desc = "New Terminal Instance" })

    vim.keymap.set({ "n", "t" }, "<" .. decorate .. "-j>", function()
      if vim.bo.filetype == "snacks_picker_list" then
        vim.cmd("wincmd p")
      end

      local terms = require("toggleterm.terminal").get_all()
      if #terms == 0 then
        local new_id = #terms + 1
        vim.cmd(new_id .. "ToggleTerm direction=horizontal")
      else
        require("toggleterm").toggle_all()
      end
    end, { desc = "Toggle All Terminals" })

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      group = vim.api.nvim_create_augroup("user_toggle_wincmd_keymap_for_lazygit_term_buf", { clear = true }),
      callback = function()
        local term_title = vim.b.term_title
        if term_title and term_title:match("lazygit") then
          vim.keymap.set({ "n", "t", "i" }, "<C-h>", "", { silent = true, buffer = true })
          vim.keymap.set({ "n", "t", "i" }, "<C-l>", "", { silent = true, buffer = true })
          vim.keymap.set({ "n", "t", "i" }, "<C-j>", "", { silent = true, buffer = true })
          vim.keymap.set({ "n", "t", "i" }, "<C-k>", "", { silent = true, buffer = true })
          vim.keymap.set({ "n", "t", "i" }, "<Esc>", "<Esc>", { silent = true, buffer = true })
          vim.keymap.set({ "n", "t", "i" }, "<C-c>", "<C-c>", { silent = true, buffer = true })
        end
      end,
    })
  end,
}

return M
