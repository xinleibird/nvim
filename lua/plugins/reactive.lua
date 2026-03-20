local apply_background = function()
  if vim.o.background == "light" then
    local latte = require("catppuccin.palettes").get_palette("latte")
    local lighten = require("catppuccin.utils.colors").lighten
    require("reactive").setup({
      configs = {
        ["catppuccin-latte-cursorline"] = {
          static = {
            winhl = {
              inactive = {
                CursorLine = { bg = lighten(latte.mantle, 0.7, latte.base) },
                CursorLineNr = { bg = lighten(latte.mantle, 0.7, latte.base) },
              },
            },
          },
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
          static = {
            winhl = {
              inactive = {
                CursorLine = { bg = darken(mocha.surface0, 0.64, mocha.base) },
                CursorLineNr = { bg = darken(mocha.surface0, 0.64, mocha.base) },
              },
            },
          },

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
end

---@module "lazy"
---@type LazySpec
local M = {
  "rasulomaroff/reactive.nvim",
  event = { "BufRead", "User SnacksDashboardClosed" },
  config = function()
    apply_background()

    vim.api.nvim_create_autocmd({ "OptionSet" }, {
      pattern = "background",
      group = vim.api.nvim_create_augroup("user_reactive_background_changed", { clear = true }),
      callback = function()
        apply_background()
      end,
    })
  end,
}

return M
