---@module "lazy"
---@type LazySpec
local M = {
  "rasulomaroff/reactive.nvim",
  event = "BufEnter *.*",
  init = function()
    vim.api.nvim_create_autocmd({ "OptionSet" }, {
      pattern = "background",
      group = vim.api.nvim_create_augroup("user_colorscheme_changed", { clear = true }),
      callback = function()
        if vim.o.background == "light" then
          local latte = require("catppuccin.palettes").get_palette("latte")
          local lighten = require("catppuccin.utils.colors").lighten
          require("reactive").setup({
            configs = {
              ["catppuccin-latte-cursorline"] = {
                modes = {
                  R = {
                    winhl = {
                      CursorLine = { bg = lighten(latte.red, 0.5) },
                      CursorLineNr = { bg = lighten(latte.red, 0.5) },
                    },
                  },
                },
              },
            },
            load = { "catppuccin-latte-cursor", "catppuccin-latte-cursorline" },
          })
          vim.cmd([[Reactive disable_all]])
          vim.cmd([[Reactive enable catppuccin-latte-cursor]])
          vim.cmd([[Reactive enable catppuccin-latte-cursorline]])
        end

        if vim.o.background == "dark" then
          local mocha = require("catppuccin.palettes").get_palette("mocha")
          local darken = require("catppuccin.utils.colors").darken
          require("reactive").setup({
            configs = {
              ["catppuccin-mocha-cursorline"] = {
                modes = {
                  R = {
                    winhl = {
                      CursorLine = { bg = darken(mocha.flamingo, 0.5) },
                      CursorLineNr = { bg = darken(mocha.flamingo, 0.5) },
                    },
                  },
                },
              },
            },
            load = { "catppuccin-mocha-cursor", "catppuccin-mocha-cursorline" },
          })
          vim.cmd([[Reactive disable_all]])
          vim.cmd([[Reactive enable catppuccin-mocha-cursor]])
          vim.cmd([[Reactive enable catppuccin-mocha-cursorline]])
        end
      end,
    })
  end,
}

return M
