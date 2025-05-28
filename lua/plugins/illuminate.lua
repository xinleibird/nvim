local M = {
  "RRethy/vim-illuminate",
  event = "BufRead",
  init = function()
    vim.keymap.set("n", "]]", require("illuminate").goto_next_reference, { desc = "Next reference" })
    vim.keymap.set("n", "[[", require("illuminate").goto_prev_reference, { desc = "Prev reference" })
    vim.keymap.set("n", "gt", require("illuminate").textobj_select, { desc = "Prev reference" })
  end,
  config = function()
    require("illuminate").configure({
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      delay = 100,
      filetypes_denylist = {
        "DressingSelect",
        "Outline",
        "TelescopePrompt",
        "Trouble",
        "alpha",
        "dirvish",
        "fugitive",
        "help",
        "lazy",
        "mason",
        "lir",
        "gitcommit",
        "neo-tree",
        "spectre_panel",
        "toggleterm",
        "NeogitStatus",
        "checkhealth",
        "",
      },
      under_cursor = true,
    })
  end,
}

return M
