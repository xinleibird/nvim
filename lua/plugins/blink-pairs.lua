---@module "lazy"
---@type LazySpec
local M = {
  "saghen/blink.pairs",
  -- version = "*", -- (recommended) only required with prebuilt binaries
  lazy = false,

  -- download prebuilt binaries from github releases
  -- dependencies = "saghen/blink.download",
  -- OR build from source, requires nightly:
  -- https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  build = "cargo build --release",
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  init = function()
    vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
      group = vim.api.nvim_create_augroup("user_cmdline_enter", { clear = true }),
      callback = function()
        local type = vim.fn.getcmdtype()
        if type == "/" or type == "?" then
          vim.b.blink_pairs = false
        end
        if type == ":" or type == "@" then
          vim.b.blink_pairs = true
        end
      end,
    })
    vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
      group = vim.api.nvim_create_augroup("user_cmdline_leave", { clear = true }),
      callback = function()
        vim.b.blink_pairs = true
      end,
    })
  end,

  --- @module 'blink.pairs'
  --- @type blink.pairs.Config
  opts = {
    mappings = {
      -- you can call require("blink.pairs.mappings").enable()
      -- and require("blink.pairs.mappings").disable()
      -- to enable/disable mappings at runtime
      enabled = true,
      cmdline = true,
      -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
      -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
      disabled_filetypes = { "snacks_picker_input" },
      -- see the defaults:
      -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L14
      pairs = {
        ["`"] = {
          {
            "```",
            when = function(ctx)
              return ctx:text_before_cursor(2) == "``"
            end,
            languages = { "markdown", "markdown_inline", "typst", "vimwiki", "rmarkdown", "rmd", "quarto" },
            space = false,
          },
          {
            " ",
            "```",
            when = function(ctx)
              return (ctx:text_before_cursor(nil)):match("^```.*$")
            end,
            languages = { "markdown", "markdown_inline", "typst", "vimwiki", "rmarkdown", "rmd", "quarto" },
          },
          {
            "`",
            "'",
            languages = { "bibtex", "latex", "plaintex" },
          },
          { "`", enter = false, space = false },
        },
      },
    },
    highlights = {
      enabled = true,
      cmdline = true,
      groups = {
        "BlinkPairsRed",
        "BlinkPairsYellow",
        "BlinkPairsBlue",
        "BlinkPairsOrange",
        "BlinkPairsGreen",
        "BlinkPairsPurple",
        "BlinkPairsCyan",
      },
      unmatched_group = "BlinkPairsUnmatched",

      -- highlights matching pairs under the cursor
      matchparen = {
        enabled = true,
        -- known issue where typing won't update matchparen highlight, disabled by default
        cmdline = false,
        -- also include pairs not on top of the cursor, but surrounding the cursor
        include_surrounding = false,
        group = "BlinkPairsMatchParen",
        priority = 250,
      },
    },
    debug = false,
  },
}

return M
