local M = {
  "numToStr/FTerm.nvim",
  event = "ColorScheme",
  init = function()
    local function get_map()
      ---@diagnostic disable-next-line: deprecated
      if vim.g.neovide or vim.api.nvim_command_output("echo &term") == "xterm-kitty" then
        return "<D-j>"
      else
        return "<M-j>"
      end
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
        width = 0.98,
        x = 0.5,
        y = 0.88,
      },
    })
  end,
}

return M
