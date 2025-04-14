local M = {
  "folke/snacks.nvim",
  priority = 1000,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "ahmedkhalf/project.nvim",
    "olimorris/persisted.nvim",
  },
  init = function()
    local group = vim.api.nvim_create_augroup("user_disable_mouse_when_snacks_dashboard", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "SnacksDashboardOpened",
      command = "set mouse=",
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "SnacksDashboardClosed",
      command = "set mouse=a",
    })

    vim.cmd(
      [[command! -nargs=? -complete=checkhealth Checkhealth vert checkhealth <args> | setlocal bufhidden=wipe nomodifiable nobuflisted noswapfile nocursorline nocursorcolumn norelativenumber noruler nolist noshowmode noshowcmd | file <args>\ health]]
    )
  end,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    image = { enabled = true },
    input = { enabled = true },
    indent = {
      indent = {
        enabled = true,
        priority = 1,
        char = "▏",
        only_scope = false,
        only_current = false,
        hl = "SnacksIndent",
      },
      animate = {
        enabled = vim.fn.has("nvim-0.10") == 1,
        style = "out",
        easing = "linear",
        duration = {
          step = 10,
          total = 100,
        },
      },
      scope = {
        enabled = true,
        priority = 200,
        char = "▏",
        underline = false,
        only_current = false,
        hl = "SnacksIndentScope",
      },
    },
    dashboard = {
      preset = {
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
            icon = "󰙩 ",
            key = "st",
            desc = "Live Grep",
            action = ":lua require('telescope.builtin').live_grep()",
          },
          {
            icon = " ",
            key = "ss",
            desc = "Restore Session",
            action = ":SessionSelect",
          },
          {
            icon = " ",
            key = "<leader>q",
            desc = "Quit",
            action = ":qa",
          },
        },
      },
      sections = function()
        return {
          {
            section = "terminal",
            enabled = function()
              return vim.api.nvim_win_get_width(1000) == vim.o.columns
                and vim.api.nvim_win_get_height(1000) >= vim.o.lines - 3
            end,
            cmd = "chafa ~/.config/nvim/assets/sprites/necroma_idle.gif -p off --speed=0.62 --clear --passthrough=tmux --format symbols --symbols vhalf --size 40x28 --stretch",
            height = 28,
            padding = 0,
            align = "left",
            pane = 1,
          },
          {
            {
              text = {
                {
                  table.concat({
                    table.concat({
                      [[        ┳┓      ]],
                      vim.o.background == "dark" and " " or "☀︎ ",
                      [[         ]],
                    }, ""),
                    [[        ┃┃┏┓┏┓┓┏┓┏┳┓        ]],
                    [[╍╸╺╺╸╸╸╺┛┗┗ ┗┛┗┛┗┛┗┗╺╸╸╺╺╸╺╍]],
                  }, "\n"),
                  hl = "SnacksDashboardHeader",
                },
              },
            },
            {
              text = {
                {
                  table.concat({
                    [[        ┓┏┏ ┏┓┏┓┏┓┏┏        ]],
                    [[        ┃┃┗┛┗┛┛┗┛┗┻┛        ]],

                    table.concat({
                      [[        ┻┛      ]],
                      vim.o.background == "dark" and " " or "☀︎ ",
                      [[         ]],
                    }, ""),
                  }, "\n"),
                  hl = "SnacksDashboardHeaderReflection",
                },
              },
            },
            pane = 2,
            padding = 2,
            align = "center",
          },
          {
            { icon = " ", title = "Recent Files", section = "recent_files", gap = 0, indent = 3, padding = 1 },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
            pane = 2,
          },
        }
      end,
    },
  },
}

return M
