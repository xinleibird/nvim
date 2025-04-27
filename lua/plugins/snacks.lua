local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = {
    "olimorris/persisted.nvim",
    {
      "wsdjeg/rooter.nvim",
      config = function()
        require("rooter").setup({
          root_pattern = { ".git/", "package.json" },
          command = "cd",
        })
      end,
    },
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

    vim.keymap.set("n", "<leader>sP", "<cmd>lua Snacks.picker.projects()<CR>", { desc = "Recent projects" })
    vim.keymap.set("n", "<leader>sp", "<cmd>lua Snacks.picker.pick('files')<cr>", { desc = "Files" })
    vim.keymap.set("n", "<leader>st", "<cmd>lua Snacks.picker.pick('live_grep')<CR>", { desc = "Live grep" })
    vim.keymap.set("n", "<leader>sc", "<cmd>lua Snacks.picker.smart()<CR>", { desc = "Text under cursor" })
    vim.keymap.set("n", "<leader>sh", "<cmd>lua Snacks.picker.help()<CR>", { desc = "Help pages" })
    vim.keymap.set("n", "<leader>sr", "<cmd>lua Snacks.picker.pick('oldfiles')<CR>", { desc = "Recent files" })
    vim.keymap.set("n", "<leader>sb", "<cmd>lua Snacks.picker.lines()<CR>", { desc = "Buffer lines" })
    vim.keymap.set("n", "<leader>sB", "<cmd>lua Snacks.picker.grep_buffers()<CR>", { desc = "Open buffers" })
    vim.keymap.set({ "n", "x" }, "<leader>sw", "<cmd>lua Snacks.picker.grep_word()<CR>", { desc = "Selected word" })

    vim.keymap.set("n", "<leader>gg", "<cmd>lua Snacks.lazygit()<CR>", { desc = "Lazygit" })
    vim.keymap.set("n", "<leader>go", "<cmd>lua Snacks.picker.git_status()<CR>", { desc = "Git status" })

    vim.keymap.set("n", "<leader>e", "<cmd>lua Snacks.picker.explorer()<CR>", { desc = "Explorer" })

    vim.keymap.set("n", "]]", "<cmd>lua Snacks.words.jump(vim.v.count1)<CR>", { desc = "Next reference" })
    vim.keymap.set("n", "[[", "<cmd>lua Snacks.words.jump(-vim.v.count1)<CR>", { desc = "Next reference" })

    -- vim.cmd(
    --   [[command! -nargs=? -complete=checkhealth Checkhealth vert checkhealth <args> | setlocal bufhidden=wipe nomodifiable nobuflisted noswapfile nocursorline nocursorcolumn norelativenumber noruler nolist noshowmode noshowcmd | file <args>\ health]]
    -- )

    vim.cmd([[command! Notifications lua Snacks.notifier.show_history()]])
    vim.cmd([[command! Pickers lua Snacks.picker()]])

    local term_group = vim.api.nvim_create_augroup("user_toggle_wincmd_keymap_for_lazygit_term_buf", { clear = true })
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      group = term_group,
      callback = function()
        local term_title = vim.b.term_title
        if term_title and term_title:match("lazygit") then
          vim.keymap.del({ "n", "t", "i" }, "<C-h>")
          vim.keymap.del({ "n", "t", "i" }, "<C-l>")
          vim.keymap.del({ "n", "t", "i" }, "<C-j>")
          vim.keymap.del({ "n", "t", "i" }, "<C-k>")
        end
      end,
    })
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*",
      callback = function()
        local term_title = vim.b.term_title
        if term_title and term_title:match("lazygit") then
          vim.keymap.set({ "n", "t", "i" }, "<C-h>", "<cmd>wincmd h<CR>", { desc = "Jump left window" })
          vim.keymap.set({ "n", "t", "i" }, "<C-l>", "<cmd>wincmd l<CR>", { desc = "Jump right window" })
          vim.keymap.set({ "n", "t", "i" }, "<C-j>", "<cmd>wincmd j<CR>", { desc = "Jump down window" })
          vim.keymap.set({ "n", "t", "i" }, "<C-k>", "<cmd>wincmd k<CR>", { desc = "Jump up window" })
        end
      end,
    })
  end,

  ---@type snacks.Config
  opts = {
    styles = {
      minimal = {
        relative = {},
        wo = {
          fillchars = "eob: ,lastline:…,horiz: ,horizdown: ,horizup: ,vert: ,verthoriz: ,vertleft: ,vertright: ",
        },
      },
    },
    bigfile = { enabled = true },
    image = { enabled = true },
    input = { enabled = true },
    scope = { enabled = true },
    words = { enabled = true },
    lazygit = {
      config = {
        os = {
          edit = '[ -z ""$NVIM"" ] && (nvim -- {{filename}}) || (nvim --server ""$NVIM"" --remote-send ""q"" && nvim --server ""$NVIM"" --remote {{filename}})',
        },
      },
    },
    notifier = { timeout = 2000 },
    picker = {
      ---@diagnostic disable-next-line: missing-fields
      icons = {
        tree = {
          vertical = "│ ",
          middle = "├ ",
          last = "└ ",
        },
      },
      prompt = "   ",
      layout = "default_layout",
      sources = {
        buffers = { layout = { preset = "vertical_layout" } },
        recent = { layout = { preset = "vertical_layout" }, title = "Most Recently Used Files" },
        explorer = { layout = { preset = "explorer_layout" } },
      },
      layouts = {
        default_layout = {
          layout = {
            box = "vertical",
            width = 0.9,
            height = 0.9,
            border = "none",
            {
              win = "input",
              height = 1,
              border = "single",
              title = "Find {title} {live} {flags}",
              title_pos = "center",
            },
            {
              box = "horizontal",
              { win = "list", border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" } },
              { win = "preview", border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, width = 0.6 },
            },
          },
        },
        vertical_layout = {
          layout = {
            box = "vertical",
            width = 0.8,
            height = 0.9,
            border = "none",
            {
              win = "input",
              border = "single",
              height = 1,
              title = "Find {title} {live} {flags}",
              title_pos = "center",
            },
            { win = "list", border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, height = 8 },
            { win = "preview", border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" } },
          },
        },
        explorer_layout = {
          preview = "main",
          layout = {
            backdrop = false,
            width = 27,
            min_width = 27,
            height = 0,
            position = "left",
            border = "none",
            box = "vertical",
            {
              win = "list",
              border = "none",
            },
            {
              win = "input",
              height = 1,
              border = "none",
              title = "{title} {live} {flags}",
              title_pos = "center",
            },
            {
              win = "preview",
              title = "{preview}",
              height = 0.5,
              border = "top",
            },
          },
        },
      },
    },
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
          { icon = " ", key = "sP", desc = "Projects", action = ":lua Snacks.picker.projects()" },
          { icon = " ", key = "sr", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "sp", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = "󰙩 ", key = "st", desc = "Live Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "ss", desc = "Restore Session", action = ":SessionSelect" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
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
