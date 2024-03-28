local M = {
  "akinsho/toggleterm.nvim",
  event = "VimEnter",
  version = "*",
  init = function()
    local maps = "<M-j>"
    if vim.g.neovide then
      maps = "<D-j>"
    end

    vim.keymap.set({ "n", "t" }, maps, "<cmd>ToggleTerm<CR>", { desc = "Terminal New horizontal term" })

    vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })
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
        -- FloatBorder = {
        --   guifg = "<VALUE-HERE>",
        --   guibg = "<VALUE-HERE>",
        -- },
      },
      winbar = {
        enabled = false,
        name_formatter = function(term) --  term: Terminal
          return term.name
        end,
      },
    })
  end,
}

return M
