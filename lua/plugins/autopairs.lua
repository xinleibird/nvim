local M = {
  "windwp/nvim-autopairs",
  event = "BufRead",
  config = function()
    local autopairs = require("nvim-autopairs")
    local cond = require("nvim-autopairs.conds")

    autopairs.setup({
      fast_wrap = {},
      disable_filetype = { "snacks_picker_input" },
    })

    local Rule = require("nvim-autopairs.rule")
    autopairs.add_rule(Rule("```", "```", { "codecompanion" }))

    -- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#auto-pair--for-generics-but-not-as-greater-thanless-than-operators
    autopairs.add_rule(Rule("<", ">", {
      "-html",
      "-javascriptreact",
      "-typescriptreact",
    }):with_pair(cond.before_regex("%a+:?:?$", 3)):with_move(function(opts)
      return opts.char == ">"
    end))
  end,
}

return M
