---@module "lazy"
---@type LazySpec
local M = {
  "folke/sidekick.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  dependencies = {
    {
      "folke/snacks.nvim",
      optional = true,
      opts = {
        picker = {
          actions = {
            sidekick_send = function(...)
              return require("sidekick.cli.picker.snacks").send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = {
                  "sidekick_send",
                  mode = { "n", "i" },
                },
              },
            },
          },
        },
      },
    },
  },
  opts = {
    -- add any options here
    nes = { enabled = false },
    cli = {
      win = {
        layout = "right",
        split = {
          width = 82,
          height = 20,
        },
        float = {
          width = 0.8,
          height = 0.8,
        },
      },
      mux = {
        enabled = false,
      },
    },
  },
  keys = function()
    local cli_name = "opencode"
    return {
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
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
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
    }
  end,
}

return M
