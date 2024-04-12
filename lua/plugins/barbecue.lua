local M = {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  event = "LspAttach",
  config = function()
    require("barbecue").setup({
      create_autocmd = false,
      -- https://github.com/neovide/neovide/pull/2165
      lead_custom_section = function()
        return { { " ", "WinBar" } }
      end,
      symbols = {
        modified = require("configs.icons").ui.Modified,
        ellipsis = require("configs.icons").ui.Ellipsis,
        separator = require("configs.icons").ui.ChevronRight,
      },
      theme = "catppuccin", -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
      exclude_filetypes = { "netrw", "toggleterm" },
    })

    vim.api.nvim_create_autocmd({ "BufWinEnter", "CursorHold", "BufModifiedSet" }, {
      group = vim.api.nvim_create_augroup("barbecue.updater", {}),
      callback = function(opts)
        if vim.bo[opts.buf].filetype == "toggleterm" then
          return
        end
        require("barbecue.ui").update()
      end,
    })
  end,
}

return M
