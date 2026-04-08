---@module "lazy"
---@type LazySpec
local M = {
  "saghen/blink.pairs",
  version = "*", -- (recommended) only required with prebuilt binaries
  lazy = false,
  -- download prebuilt binaries from github releases
  dependencies = {
    "saghen/blink.download",
    {
      "windwp/nvim-autopairs",
      config = function()
        local autopairs = require("nvim-autopairs")
        local cond = require("nvim-autopairs.conds")
        autopairs.setup({
          fast_wrap = {},
          disable_filetype = { "snacks_picker_input" },
        })

        local Rule = require("nvim-autopairs.rule")

        autopairs.add_rule(Rule("```", "```", { "codecompanion" }):with_pair(cond.not_before_char("`", 3)))
        autopairs.add_rule(Rule("```.*$", "```", { "codecompanion" }):only_cr():use_regex(true))

        -- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#auto-pair--for-generics-but-not-as-greater-thanless-than-operators
        autopairs.add_rule(Rule("<", ">", {
          "-html",
          "-javascriptreact",
          "-typescriptreact",
          "-vue",
          "-svelte",
          "-astro",
        }):with_pair(cond.before_regex("%a+:?:?$", 3)):with_move(function(opts)
          return opts.char == ">"
        end))
      end,
    },
  },
  -- OR build from source, requires nightly:
  -- https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = "cargo build --release",
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  --- @module 'blink.pairs'
  --- @type blink.pairs.Config
  opts = {
    mappings = {
      -- you can call require("blink.pairs.mappings").enable()
      -- and require("blink.pairs.mappings").disable()
      -- to enable/disable mappings at runtime
      enabled = false,
      cmdline = false,
      -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
      -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
      disabled_filetypes = { "snacks_picker_input" },
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
