---@module "lazy"
---@type LazySpec
local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    vim.cmd([[command! Notifications lua Snacks.notifier.show_history()]])
    vim.cmd([[command! Pickers lua Snacks.picker()]])
  end,
  keys = {
    --stylua: ignore start
    { "<leader>sp", function() Snacks.picker.smart() end,  desc = "Smart Files" },
    { "<leader>sP", function() Snacks.picker.projects() end,  desc = "Recent Projects" },
    { "<leader>so", function() Snacks.picker.files() end,  desc = "Find Files" },
    { "<leader>st", function() Snacks.picker.grep({exclude ={"package-lock.json"}}) end, desc = "Live grep" },
    { "<leader>sx", function() Snacks.picker.grep_word() end, desc = "Grep word" , mode ={ "n", "x" } },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help pages" },
    { "<leader>sr", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end,  desc = "Open buffers" },
    { "<leader>go", function() Snacks.picker.git_status() end, desc = "Git status" },
    { "<leader>gO", function() Snacks.picker.git_diff() end, desc = "Git diff (Hunks)" },
    { "<leader>e", function() Snacks.picker.explorer() end, desc = "Explorer" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" },
    {"<C-x>", "<C-\\><C-N>", { desc = "Escape terminal mode" }, mode ="t"},
    { "<leader>ld", function() Snacks.picker.diagnostics_buffer() end,  desc = "Buff diagnostics" },
    { "<leader>lD", function() Snacks.picker.diagnostics() end,  desc = "Diagnostics" },
    { "<leader>gg", function()
      local root = Snacks.git.get_root()
      if root ~= nil then
        Snacks.lazygit()
      else
        vim.notify("Not in a git repository!", vim.log.levels.WARN, { title = "Lazygit" })
      end
    end,  desc = "Lazygit" },
    -- stylua: ignore end
  },

  config = function()
    local icons = require("configs.icons")
    local home_dir = vim.fn.expand("$HOME")
    local homebrew_repo = vim.fn.expand("$HOMEBREW_REPOSITORY")
    local data_dir = vim.fn.stdpath("data")
    local cache_dir = vim.fn.stdpath("cache")
    local state_dir = vim.fn.stdpath("state")
    local function filter_rtp(rtp)
      local patterns = {
        "^" .. "/" .. "$",
        "^" .. "/private/",
        "^" .. homebrew_repo,
        "^" .. data_dir,
        "^" .. cache_dir,
        "^" .. state_dir,
        "^" .. home_dir .. "/.rustup",
        "^" .. home_dir .. "/.notes",
        "^" .. home_dir .. "/.ssh",
        "node_modules",
      }
      for _, pattern in ipairs(patterns) do
        if rtp:match(pattern) then
          return false
        end
      end
      return true
    end
    require("snacks").setup({
      styles = {
        minimal = {
          relative = {},
          wo = {
            -- fillchars = "eob: ,lastline:…,horiz:⠂,horizdown:⠂,horizup:⠂,vert:⠅,verthoriz:⠂,vertleft:⠅,vertright:⠅",
            fillchars = "eob: ,lastline:…,vert:│",
          },
        },
        notification = {
          wo = {
            winblend = 0,
          },
        },
      },
      indent = { enabled = false },
      scope = { enabled = false },
      explorer = { enabled = true },
      image = { enabled = true },
      input = { enabled = true },
      quickfile = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      bigfile = { enabled = true },
      notifier = {
        timeout = 2000,
        icons = {
          error = require("configs.icons").diagnostics.Error,
          warn = require("configs.icons").diagnostics.Warn,
          info = require("configs.icons").diagnostics.Info,
          debug = require("configs.icons").ui.Bug,
          trace = require("configs.icons").ui.Track,
        },
      },
      win = { backdrop = 38 },
      picker = {
        icons = {
          tree = {
            vertical = "  ",
            middle = "  ",
            last = "  ",
          },
          ui = {
            hidden = icons.ui.Hidden,
            ignored = icons.ui.Ignored,
            follow = icons.ui.Follow,
            selected = icons.ui.Checked .. " ",
            unselected = icons.ui.Unchecked .. " ",
          },
          git = {
            enabled = true, -- show git icons
            commit = icons.git.Commit .. " ", -- used by git log
            staged = icons.git.Staged, -- staged changes. always overrides the type icons
            added = icons.git.Added,
            deleted = icons.git.Deleted,
            ignored = icons.git.Ignored .. " ",
            modified = icons.git.Unstaged,
            renamed = icons.git.Unstaged,
            unmerged = icons.git.Unmerged .. " ",
            untracked = icons.git.Untracked,
          },
        },
        win = {
          input = {
            keys = {
              ["<c-`>"] = { "loclist", mode = { "i", "n" } },
              ["<c-h>"] = { "focus_input", mode = { "i", "n" } },
              ["<c-l>"] = { "focus_input", mode = { "i", "n" } },
              ["<c-j>"] = { "focus_list", mode = { "i", "n" } },
              ["<c-k>"] = { "focus_list", mode = { "i", "n" } },
              ["<c-u>"] = "",
            },
          },
          list = {
            keys = {
              ["<c-`>"] = "loclist",
              ["<c-h>"] = "focus_list",
            },
          },
        },
        prompt = "   ",
        layout = "default",
        sources = {
          projects = {
            layout = {
              preset = "select",
            },
            finder = "recent_projects",
            format = "file",
            dev = { "~/dev", "~/projects" },
            confirm = "load_session",
            matcher = {
              frecency = true, -- use frecency boosting
              sort_empty = true, -- sort even when the filter is empty
              cwd_bonus = true,
            },
            filter = {
              filter = function(item)
                return filter_rtp(item.file)
              end,
            },
          },
          buffers = { layout = { preset = "vertical" } },
          explorer = {
            layout = { preset = "sidebar" },
            on_show = function(picker)
              local show = false
              local gap = 1
              local min_width, max_width = 20, 100
              --
              local rel = picker.layout.root
              local update = function(win) ---@param win snacks.win
                if rel.win == nil then
                  return
                end
                win.opts.row = vim.api.nvim_win_get_position(rel.win)[1]
                win.opts.col = vim.api.nvim_win_get_width(rel.win) + gap
                win.opts.height = 0.8
                local border = win:border_size().left + win:border_size().right
                win.opts.width = math.max(min_width, math.min(max_width, vim.o.columns - border - win.opts.col))
                win:update()
              end
              local preview_win = Snacks.win.new({
                relative = "editor",
                external = false,
                focusable = false,
                border = "rounded",
                backdrop = false,
                show = show,
                bo = {
                  filetype = "snacks_float_preview",
                  buftype = "nofile",
                  buflisted = false,
                  swapfile = false,
                  undofile = false,
                },
                on_win = function(win)
                  update(win)
                  picker:show_preview()
                end,
              })
              rel:on("WinResized", function()
                update(preview_win)
              end)
              picker.preview.win = preview_win
              picker.main = preview_win.win
            end,
            on_close = function(picker)
              picker.preview.win:close()
            end,
            actions = {
              toggle_preview = function(picker) --[[Overrides]]
                picker.preview.win:toggle()
              end,
            },
          },
          recent = {
            layout = { preset = "vertical" },
            title = "Most Recently Used Files",
            filter = {
              filter = function(item)
                return filter_rtp(item.file)
              end,
            },
          },
        },
        layouts = {
          default = {
            layout = {
              box = "vertical",
              width = 0.9,
              height = 0.9,
              border = "none",
              {
                win = "input",
                height = 1,
                border = "solid",
                title = "Find {title} {live} {flags}",
                title_pos = "center",
              },
              {
                box = "horizontal",
                { win = "list", border = "solid" },
                {
                  win = "preview",
                  border = "solid",
                  width = 0.6,
                },
              },
            },
          },
          vertical = {
            layout = {
              box = "vertical",
              width = 0.8,
              height = 0.9,
              border = "none",
              {
                win = "input",
                border = "solid",
                height = 1,
                title = "Find {title} {live} {flags}",
                title_pos = "center",
              },
              { win = "list", border = "solid", height = 8 },
              { win = "preview", border = "solid" },
            },
          },
          sidebar = {
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
            },
          },
          vscode = {
            layout = {
              row = 2,
              width = 0.55,
              min_width = 80,
              height = 0.55,
              border = "none",
              box = "vertical",
              { win = "input", height = 1, border = "solid", title = "{title} {live} {flags}", title_pos = "center" },
              { win = "list", border = "solid" },
              { win = "preview", title = "{preview}", border = "solid" },
            },
          },
          ivy = {
            layout = {
              box = "vertical",
              backdrop = false,
              row = -1,
              width = 0,
              height = 0.4,
              title = " {title} {live} {flags}",
              title_pos = "left",
              border = "top",
              { win = "input", height = 1, border = "bottom" },
              {
                box = "horizontal",
                { win = "list", border = "solid" },
                { win = "preview", title = "{preview}", width = 0.6, border = "solid" },
              },
            },
          },
          select = {
            layout = {
              width = 0.5,
              min_width = 80,
              height = 0.4,
              min_height = 3,
              box = "vertical",
              border = "none",
              title = "{title}",
              title_pos = "center",
              { win = "input", height = 1, border = "solid" },
              { win = "list", border = "solid" },
            },
          },
        },
      },
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "sP", desc = "Recent Projects", action = ":lua Snacks.dashboard.pick('projects')" },
            { icon = " ", key = "sr", desc = "Old Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "sp", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "󰙩 ", key = "st", desc = "Live Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "ss", desc = "Restore Sessions", action = ":lua Snacks.dashboard.pick('session')" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa!" },
          },
        },
        sections = function()
          local gif = require("utils").detect_dark_mode() == "dark" and "monster.gif" or "bandit.gif"
          local cmd = "chafa "
            .. vim.fn.stdpath("config")
            .. "/assets/sprites/"
            .. gif
            .. " -p off --speed=1.0 --clear --passthrough=tmux --format symbols --symbols vhalf --size 56x28 --stretch --probe=off"
          return {
            {
              section = "terminal",
              enabled = function()
                return vim.api.nvim_win_get_width(1000) == vim.o.columns
                  and vim.api.nvim_win_get_height(1000) >= vim.o.lines - 3
              end,
              cmd = cmd,
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
                        require("utils").detect_dark_mode() == "dark" and " " or "☀︎ ",
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
                        require("utils").detect_dark_mode() == "dark" and " " or "☀︎ ",
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
              {
                icon = " ",
                title = "Recent Files",
                section = "recent_files",
                gap = 0,
                indent = 3,
                padding = 1,
                filter = function(file)
                  return filter_rtp(file)
                end,
              },
              { section = "keys", gap = 1, padding = 1 },
              { section = "startup" },
              pane = 2,
            },
          }
        end,
      },
    })
  end,
  dependencies = {
    {
      "folke/persistence.nvim",
      event = { "BufRead", "User SnacksDashboardClosed" },
      init = function()
        vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"
      end,
      config = function()
        require("persistence").setup({
          dir = vim.fn.stdpath("state") .. "/sessions/",
          need = 1,
          branch = true,
        })
        vim.keymap.set("n", "<leader>ss", function()
          require("persistence").select()
        end, { desc = "Restore Sessions" })
        vim.keymap.set("n", "<leader>sS", function()
          require("persistence").select()
        end, { desc = "Save Session" })
      end,
    },
  },
}

return M
