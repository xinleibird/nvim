---@module "lazy"
---@type LazySpec
local M = {
  "saghen/blink.pairs",
  version = "*", -- (recommended) only required with prebuilt binaries
  lazy = false,
  dependencies = {
    -- download prebuilt binaries from github releases
    "saghen/blink.download",
    -- OR build from source, requires nightly:
    -- https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = "cargo build --release",
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

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
          -- if you use nvim-ts-autotag, you may want to exclude these filetypes from this rule
          -- so that it doesn't conflict with nvim-ts-autotag
          "-html",
        }):with_pair(
          -- regex will make it so that it will auto-pair on
          -- `a<` but not `a <`
          -- The `:?:?` part makes it also
          -- work on Rust generics like `some_func::<T>()`
          cond.before_regex("%a+:?:?$", 3)
        ):with_move(function(opts)
          return opts.char == ">"
        end))

        local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
        autopairs.add_rules({
          -- Rule for a pair with left-side ' ' and right side ' '
          Rule(" ", " ")
            -- Pair will only occur if the conditional function returns true
            :with_pair(function(opts)
              -- We are checking if we are inserting a space in (), [], or {}
              local pair = opts.line:sub(opts.col - 1, opts.col)
              return vim.tbl_contains({
                brackets[1][1] .. brackets[1][2],
                brackets[2][1] .. brackets[2][2],
                brackets[3][1] .. brackets[3][2],
              }, pair)
            end)
            :with_move(cond.none())
            :with_cr(cond.none())
            -- We only want to delete the pair of spaces when the cursor is as such: ( | )
            :with_del(
              function(opts)
                local col = vim.api.nvim_win_get_cursor(0)[2]
                local context = opts.line:sub(col - 1, col + 2)
                return vim.tbl_contains({
                  brackets[1][1] .. "  " .. brackets[1][2],
                  brackets[2][1] .. "  " .. brackets[2][2],
                  brackets[3][1] .. "  " .. brackets[3][2],
                }, context)
              end
            ),
        })
        -- For each pair of brackets we will add another rule
        for _, bracket in pairs(brackets) do
          autopairs.add_rules({
            -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
            Rule(bracket[1] .. " ", " " .. bracket[2])
              :with_pair(cond.none())
              :with_move(function(opts)
                return opts.char == bracket[2]
              end)
              :with_del(cond.none())
              :use_key(bracket[2])
              -- Removes the trailing whitespace that can occur without this
              :replace_map_cr(function(_)
                return "<C-c>2xi<CR><C-c>O"
              end),
          })
        end
      end,
    },
  },

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
