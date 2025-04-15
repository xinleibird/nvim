local M = {
  "RRethy/vim-illuminate",
  event = "BufRead",
  config = function()
    require("illuminate").configure({
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      -- delay: delay in milliseconds
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
        "neogitstatus",
        "gitcommit",
        "neo-tree",
        "spectre_panel",
        "toggleterm",
        "",
      },
      under_cursor = true,
    })
  end,
}

return M
