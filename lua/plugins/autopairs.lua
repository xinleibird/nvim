local M = {
  "windwp/nvim-autopairs",
  event = "BufRead",
  dependencies = {
    "hrsh7th/nvim-cmp",
    {
      "windwp/nvim-ts-autotag",
      event = "BufRead",
      config = function()
        require("nvim-ts-autotag").setup({
          opts = {
            enable_close = false, -- Auto close tags
            enable_rename = false, -- Auto rename pairs of tags
            enable_close_on_slash = true, -- Auto close on trailing </
          },
        })
      end,
    },
  },
  config = function()
    require("nvim-autopairs").setup({
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    })

    -- setup cmp for autopairs
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}

return M
