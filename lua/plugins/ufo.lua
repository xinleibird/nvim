local M = {
  "kevinhwang91/nvim-ufo",
  event = "BufRead",
  dependencies = "kevinhwang91/promise-async",
  init = function()
    vim.o.foldcolumn = "0" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open All Folds" })
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close All Folds" })
  end,

  config = function()
    require("ufo").setup({
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
      filetype_exclude = { "help", "lazy", "mason", "codecompanion", "snacks_picker_list", "Outline", "toggleterm" },
    })
  end,
}

return M
