local M = {
  "akinsho/toggleterm.nvim",
  event = "ColorScheme",
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
    })
  end,
}

return M
