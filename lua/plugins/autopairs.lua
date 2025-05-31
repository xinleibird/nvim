local M = {
  "windwp/nvim-autopairs",
  event = "BufRead",
  dependencies = {
    "windwp/nvim-ts-autotag",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = false, -- Auto close tags
          enable_rename = false, -- Auto rename pairs of tags
          enable_close_on_slash = true, -- Auto close on trailing </
        },
      })
    end,
  },
  config = function()
    local autopairs = require("nvim-autopairs")
    autopairs.setup({
      fast_wrap = {},
      disable_filetype = { "snacks_picker_input" },
    })

    local rule = require("nvim-autopairs.rule")
    autopairs.add_rule(rule("```", "```", { "codecompanion" }))
  end,
}

return M
