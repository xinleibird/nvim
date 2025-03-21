local M = {
  "akinsho/toggleterm.nvim",
  event = "VimEnter",
  version = "*",
  init = function()
    local function get_map()
      if vim.g.neovide then
        return "<D-j>"
      else
        return "<M-j>"
      end
    end

    vim.keymap.set({ "n", "t" }, get_map(), "<cmd>ToggleTerm<CR>", { desc = "Horizontal term" })
    vim.keymap.set({ "n", "t" }, "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Horizontal term" })

    vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "Escape terminal mode" })
  end,
  config = function()
    require("toggleterm").setup({
      highlights = {
        Normal = {
          link = "ToggleTermBg",
        },
        NormalFloat = {
          link = "ToggleTermBg",
        },
        SignColumn = {
          link = "ToggleTermBg",
        },
      },
      winbar = {
        enabled = false,
        name_formatter = function(term)
          return term.name
        end,
      },
      on_open = function()
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
          local current_buf = vim.api.nvim_win_get_buf(w)
          ---@diagnostic disable-next-line: deprecated
          if vim.api.nvim_buf_get_option(current_buf, "filetype") == "neo-tree" then
            vim.defer_fn(function()
              vim.cmd("Neotree toggle")
              vim.cmd("Neotree toggle")
              vim.cmd("wincmd p")
            end, 100)
          end
        end
      end,
    })
  end,
}

return M
