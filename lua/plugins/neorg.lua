local M = {
  "nvim-neorg/neorg",
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
          -- config = { -- We added a `config` table!
          --   icon_preset = "varied", -- And we set our option here.
          -- },
        },
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              default = "~/Local/Neorg/default",
              notes = "~/Local/Neorg/notes",
            },
            default_workspace = "default",
            -- open_last_workspace = true,
          },
        },
      },
    })
  end,
}

return M
