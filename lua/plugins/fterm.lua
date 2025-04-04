local M = {
  "numToStr/FTerm.nvim",
  event = "ColorScheme",

  init = function()
    local function get_map()
      if vim.g.neovide then
        return "<D-j>"
      end

      if vim.env.TERM and (vim.env.TERM == "xterm-kitty" or vim.env.TERM == "xterm-ghostty") then
        return "<D-j>"
      end

      return "<M-j>"
    end
    vim.keymap.set({ "n", "t" }, get_map(), '<CMD>lua require("FTerm").toggle()<CR>')
    vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "Escape terminal mode" })
  end,
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("FTerm").setup({
      border = "rounded",
      dimensions = {
        height = 0.5,
        width = 1,
        x = 0.5,
        y = 0.88,
      },
    })
  end,
}

return M
