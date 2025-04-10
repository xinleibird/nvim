local M = {
  "folke/snacks.nvim",
  init = function()
    vim.keymap.set("n", ";", function()
      local wins = vim.api.nvim_list_wins()
      local dashes = {}

      for _, w in ipairs(wins) do
        local b = vim.api.nvim_win_get_buf(w)

        if vim.bo[b].filetype == "snacks_dashboard" then
          table.insert(dashes, w)
        end
      end

      if #dashes > 0 then
        for _, winr in ipairs(dashes) do
          vim.api.nvim_set_current_win(winr)
          vim.cmd("q")
        end
      else
        Snacks.dashboard()
      end
    end, { desc = "Open dashboard" })
  end,
  ---@return snacks.Config
  opts = {
    bigfile = { enabled = true },
    image = { enabled = true },
    input = { enabled = true },
    dashboard = {
      width = 62,
      preset = {
        pick = "telescope",
        keys = {
          {
            icon = " ",
            key = "sP",
            desc = "Projects",
            action = ":lua require'telescope'.extensions.projects.projects{}",
          },
          {
            icon = " ",
            key = "sr",
            desc = "Recent Files",
            action = ":lua require('telescope.builtin').oldfiles()",
          },
          {
            icon = " ",
            key = "sp",
            desc = "Find Files",
            action = ":lua require('telescope.builtin').find_files()",
          },
          {
            icon = " ",
            key = "st",
            desc = "Live Grep",
            action = ":lua require('telescope.builtin').live_grep()",
          },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },

      sections = {
        {
          section = "terminal",
          cmd = "chafa ~/.config/nvim/assets/sprites/necroma_idle.gif -p off --speed=0.62 --clear --passthrough=tmux --format symbols --symbols vhalf --size 56x28 --stretch; sleep .1",
          height = 28,
          padding = 0,
          pane = 1,
        },
        {
          {
            text = {
              table.concat({
                [[      ┈╴╴▄▄▄   ▄▄   ▄▄      ▄    ▄   ▄▄▄▄╶┈      ]],
                [[    ┈╶╴╴▄  █  ▄▄▄  ▄  █  ▄  █   ▄   ▄ █ █╴╶╶┈    ]],
                [[  ┈╴╶╴╴╶█  █  █    █  █  █  █   █   █ █ █╴╶╶╴╴┈  ]],
                [[┈╴╶╶╴╴╴󱔐▀╶╶▀╶╶▀▀▀╴╶╶▀▀╴╶╴╶▀▀╴╶╶▀▀▀󱔐╴▀╶▀╴▀╴╶╶╴╶╶╴┈]],
              }, "\n"),
              hl = "header",
            },
          },
          {
            text = {
              table.concat({
                [[       ┈▄╶╶▄╶╶▄▄▄╴╶╶▄▄╴╶╴╶▄▄╴╶╶▄▄▄┈╴▄╶▄╴▄┈       ]],
              }, "\n"),
              hl = "SnacksDashboardHeaderReflection",
            },
          },
          pane = 2,
          padding = 4,
          align = "center",
        },
        {
          { icon = " ", title = "Recent Files", section = "recent_files", gap = 0, indent = 3, padding = 3 },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
          pane = 2,
        },
      },
    },
  },
}

return M
