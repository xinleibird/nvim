local cli_name = "opencode"

---@module "lazy"
---@type LazySpec
local M = {
  "folke/sidekick.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  dependencies = {
    "folke/snacks.nvim",
    optional = true,
  },
  opts = {
    -- add any options here
    nes = { enabled = false },
    cli = {
      mux = {
        backend = "zellij",
        enabled = true,
      },
    },
  },
  keys = {
    {
      "<c-.>",
      function()
        require("sidekick.cli").focus({ name = cli_name })
      end,
      desc = "Sidekick Focus",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle({ name = cli_name })
      end,
      mode = { "n" },
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").send({ msg = "{this}", name = cli_name })
      end,
      mode = { "x" },
      desc = "Send This",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").send({ msg = "{selection}", name = cli_name })
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send({ msg = "{file}", name = cli_name })
      end,
      desc = "Send File",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
  },
}

return M
