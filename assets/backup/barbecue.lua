local M = {
  "BrunoKrugel/bbq.nvim",
  name = "barbecue",
  event = "LspAttach",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  init = function() end,
  config = function()
    require("barbecue").setup({
      create_autocmd = false,

      theme = "catppuccin", -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
      symbols = {
        modified = require("configs.icons").ui.Modified,
        ellipsis = require("configs.icons").ui.Ellipsis,
        separator = require("configs.icons").ui.ChevronRight,
      },
      exclude_filetypes = {
        "netrw",
        "toggleterm",
        "NeogitStatus",
      },
      kinds = require("configs.icons").lspkind,

      vim.api.nvim_create_autocmd({
        "WinScrolled",
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",
        "BufModifiedSet",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", { clear = true }),
        callback = function(ev)
          if vim.bo[ev.buf].filetype == "toggleterm" then
            return
          end
          require("barbecue.ui").update()
        end,
      }),
    })
  end,
}

return M
