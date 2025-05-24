local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
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

    local function toggle_terminal_map()
      if vim.g.neovide then
        return "<D-j>"
      end
      if vim.env.TERM and (vim.env.TERM == "xterm-kitty" or vim.env.TERM == "xterm-ghostty") then
        return "<D-j>"
      end
      return "<M-j>"
    end
    vim.keymap.set({ "n", "t" }, toggle_terminal_map(), function()
      Snacks.terminal.toggle()
    end)
    vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "Escape terminal mode" })

    local term_group = vim.api.nvim_create_augroup("user_toggle_wincmd_keymap_for_lazygit_term_buf", { clear = true })
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      group = term_group,
      callback = function()
        local term_title = vim.b.term_title
        if term_title and term_title:match("lazygit") then
          vim.keymap.set({ "n", "t", "i" }, "<C-h>", "", { silent = true, buffer = true })
          vim.keymap.set({ "n", "t", "i" }, "<C-l>", "", { silent = true, buffer = true })
          vim.keymap.set({ "n", "t", "i" }, "<C-j>", "", { silent = true, buffer = true })
          vim.keymap.set({ "n", "t", "i" }, "<C-k>", "", { silent = true, buffer = true })
          vim.keymap.set({ "n", "t", "i" }, "<Esc>", "", { silent = true, buffer = true })
        end
      end,
    })

    vim.keymap.set("n", "<leader>sp", "<cmd>lua Snacks.picker.pick('files')<cr>", { desc = "Files" })
    vim.keymap.set("n", "<leader>st", "<cmd>lua Snacks.picker.pick('live_grep')<CR>", { desc = "Live grep" })
    vim.keymap.set("n", "<leader>sc", "<cmd>lua Snacks.picker.grep_word()<CR>", { desc = "Text under cursor" })
    vim.keymap.set("n", "<leader>sh", "<cmd>lua Snacks.picker.help()<CR>", { desc = "Help pages" })
    vim.keymap.set("n", "<leader>sr", "<cmd>lua Snacks.picker.pick('oldfiles')<CR>", { desc = "Recent files" })
    vim.keymap.set("n", "<leader>sb", "<cmd>lua Snacks.picker.lines()<CR>", { desc = "Buffer lines" })
    vim.keymap.set("n", "<leader>sB", "<cmd>lua Snacks.picker.grep_buffers()<CR>", { desc = "Open buffers" })
    vim.keymap.set({ "n", "x" }, "<leader>sw", "<cmd>lua Snacks.picker.grep_word()<CR>", { desc = "Selected word" })

    vim.keymap.set("n", "<leader>gg", function()
      local root = Snacks.git.get_root()
      if root ~= nil then
        Snacks.lazygit()
      else
        vim.notify("Not in a git repository!", vim.log.levels.WARN, { title = "Lazygit" })
      end
    end, { desc = "Lazygit" })
    vim.keymap.set("n", "<leader>go", "<cmd>lua Snacks.picker.git_status()<CR>", { desc = "Git status" })
    vim.keymap.set("n", "<leader>gO", "<cmd>lua Snacks.picker.git_diff()<CR>", { desc = "Git diff (Hunks)" })

    vim.keymap.set("n", "<leader>e", "<cmd>lua Snacks.picker.explorer()<CR>", { desc = "Explorer" })

    vim.keymap.set("n", "]]", "<cmd>lua Snacks.words.jump(vim.v.count1)<CR>", { desc = "Next reference" })
    vim.keymap.set("n", "[[", "<cmd>lua Snacks.words.jump(-vim.v.count1)<CR>", { desc = "Next reference" })

    -- vim.cmd(
    --   [[command! -nargs=? -complete=checkhealth Checkhealth vert checkhealth <args> | setlocal bufhidden=wipe nomodifiable nobuflisted noswapfile nocursorline nocursorcolumn norelativenumber noruler nolist noshowmode noshowcmd | file <args>\ health]]
    -- )

    vim.cmd([[command! Notifications lua Snacks.notifier.show_history()]])
    vim.cmd([[command! Pickers lua Snacks.picker()]])
  end,
  ---@return snacks.Config
  opts = function()
    local home_dir = vim.fn.expand("$HOME")
    local data_dir = vim.fn.stdpath("data")
    local function filter_rtp(rtp)
      local patterns = {
        "^" .. home_dir .. "/.rustup",
        "^" .. data_dir,
        "^/opt/homebrew",
        "node_modules",
      }
      for _, pattern in ipairs(patterns) do
        if rtp:match(pattern) then
          return false
        end
      end
      return true
    end

    local icons = require("configs.icons")
    return {
      styles = {
        minimal = {
          relative = {},
          wo = {
            fillchars = "eob: ,lastline:…,horiz:⠂,horizdown:⠂,horizup:⠂,vert: ,verthoriz:⠂,vertleft:⠅,vertright:⠅",
          },
        },
      },
      image = { enabled = true },
      input = { enabled = true },
      words = { enabled = true }, -- vim-illuminate alternative
      statuscolumn = { enabled = true },
      explorer = { enabled = true },
      terminal = { enabled = true },
      bigfile = {
        size = 1.0 * 1024 * 1024, -- 1.0MB
        setup = function(ctx)
          if vim.fn.exists(":NoMatchParen") ~= 0 then
            vim.cmd([[NoMatchParen]])
          end
          Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
          vim.b.minianimate_disable = true
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ctx.buf) then
              vim.bo[ctx.buf].syntax = ctx.ft
            end
          end)
          -- for bigfile disable autofomat and autolint
          vim.b.disable_autoformat = true
          vim.b.disable_autolint = true
        end,
      },
      lazygit = {
        config = {
          os = {
            edit = '[ -z ""$NVIM"" ] && (nvim -- {{filename}}) || (nvim --server ""$NVIM"" --remote-send ""q"" && nvim --server ""$NVIM"" --remote {{filename}})',
          },
        },
      },
      notifier = { timeout = 2000 },
      win = { backdrop = 38 },
      picker = {
        ---@diagnostic disable-next-line: missing-fields
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
            },
          },
          list = {
            keys = {
              ["<c-`>"] = "loclist",
            },
          },
        },
        prompt = "   ",
        layout = "default",
        sources = {
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
              -- `<A-p>`
              toggle_preview = function(picker) --[[Override]]
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
            -- preview = "main",
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
              -- {
              --   win = "preview",
              --   title = "{preview}",
              --   height = 0.5,
              --   border = "top",
              -- },
            },
          },
          vscode = {
            preview = false,
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
              border = "none",
              title = " {title} {live} {flags}",
              title_pos = "left",
              { win = "input", height = 1, border = "solid" },
              {
                box = "horizontal",
                { win = "list", border = "solid" },
                { win = "preview", title = "{preview}", width = 0.6, border = "solid" },
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
          underline = true,
          only_current = false,
          hl = "SnacksIndentScope",
        },
      },
      scope = {
        cursor = false,
        treesitter = {
          enabled = false,
          injections = true, -- include language injections when detecting scope (useful for languages like `vue`)
          ---@type string[]|{enabled?:boolean}
          blocks = {
            enabled = true, -- enable to use the following blocks
            "function_declaration",
            "function_definition",
            "method_declaration",
            "method_definition",
            "class_declaration",
            "class_definition",
            "do_statement",
            "while_statement",
            "repeat_statement",
            "if_statement",
            "for_statement",
          },
          field_blocks = {
            "local_declaration",
          },
        },
      },
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "sP", desc = "Recent Workspaces", action = ":WorkspacesPicker" },
            { icon = " ", key = "sr", desc = "Old Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "sp", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "󰙩 ", key = "st", desc = "Live Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "ss", desc = "Restore Sessions", action = ":SessionPicker" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa!" },
          },
        },
        sections = function()
          local gif = require("utils").detect_dark_mode() == "dark" and "necroma_idle.gif" or "paladin_idle.gif"
          local cmd = "chafa "
            .. vim.fn.stdpath("config")
            .. "/assets/sprites/"
            .. gif
            .. " -p off --speed=0.62 --clear --passthrough=tmux --format symbols --symbols vhalf --size 56x28 --stretch --probe=off"
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
                filter = function(item)
                  return filter_rtp(item)
                end,
              },
              { section = "keys", gap = 1, padding = 1 },
              { section = "startup" },
              pane = 2,
            },
          }
        end,
      },
    }
  end,
  dependencies = {
    {
      "folke/edgy.nvim",
      ---@module 'edgy'
      ---@param opts Edgy.Config
      opts = function(_, opts)
        for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
          opts[pos] = opts[pos] or {}
          table.insert(opts[pos], {
            ft = "snacks_terminal",
            size = { height = 0.4 },
            title = "%{b:snacks_terminal.id}: %{b:term_title}",
            filter = function(_, win)
              return vim.w[win].snacks_win
                and vim.w[win].snacks_win.position == pos
                and vim.w[win].snacks_win.relative == "editor"
                and not vim.w[win].trouble_preview
            end,
          })
        end
      end,
    },
    {
      "olimorris/persisted.nvim",
      init = function()
        vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"

        vim.api.nvim_create_user_command("SessionPicker", function()
          local items = {}
          local longest_name = 0
          local sep = require("persisted.utils").dir_pattern()

          local function escape_pattern(str, pattern, replace, n)
            pattern = string.gsub(pattern, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
            replace = string.gsub(replace, "[%%]", "%%%%") -- escape replacement

            return string.gsub(str, pattern, replace, n)
          end

          for i, session in ipairs(require("persisted").list()) do
            local session_path = escape_pattern(session, require("persisted.config").config.save_dir, "")
              :gsub("%%", sep)
              -- :gsub(vim.fn.expand("~"), sep)
              -- :gsub(vim.fn.expand("~"), "~")
              :gsub(
                "//",
                ""
              )
              :sub(1, -5)

            if vim.fn.has("win32") == 1 then
              session_path = escape_pattern(session_path, sep, ":", 1)
              session_path = escape_pattern(session_path, sep, "\\")
            end

            local root_dir = string.match(session_path, "[^/]%w+$")

            table.insert(items, {
              idx = i,
              score = i,
              text = session_path,
              name = root_dir,
              session = session,
            })
            longest_name = math.max(longest_name, #root_dir)
          end
          longest_name = longest_name + 2
          return Snacks.picker({
            title = "Sessions",
            items = items,
            layout = "vscode",
            format = function(item)
              local ret = {}
              ret[#ret + 1] = { ("%-" .. longest_name .. "s"):format(item.name), "SnacksPickerLabel" }
              ret[#ret + 1] = { item.text, "SnacksPickerComment" }
              return ret
            end,
            confirm = function(picker, item)
              picker:close()
              require("persisted").load({ session = item.session })
            end,
          })
        end, {
          desc = "Sessions picker",
        })

        vim.keymap.set("n", "<leader>ss", "<cmd>SessionPicker<CR>", { desc = "Recent sessions" })
        vim.keymap.set("n", "<leader>sS", function()
          vim.cmd("SessionSave")
        end, { desc = "Save session" })
      end,

      config = function()
        local deny_list = {
          "snacks_dashboard",
          "snacks_layout_box", -- snacks explorer
          "dapui_scopes",
          "dapui_breakpoints",
          "dapui_stacks",
          "dapui_watches",
          "dapui_console",
          "dap-repl",
          "Outline",
          "codecompanion",
        }
        require("persisted").setup({
          should_save = function()
            for _, ft in ipairs(deny_list) do
              if vim.bo.filetype == ft then
                return false
              end
            end
            Snacks.notify("Session saved!", { title = "persisted.nvim" })
            return true
          end,
        })
      end,
    },
    {
      "natecraddock/workspaces.nvim",
      init = function()
        vim.api.nvim_create_user_command("WorkspacesPicker", function()
          local items = {}
          local longest_name = 0
          for i, workspace in ipairs(require("workspaces").get()) do
            table.insert(items, {
              idx = i,
              score = i,
              text = workspace.path,
              name = workspace.name,
              file = workspace.path,
            })
            longest_name = math.max(longest_name, #workspace.name)
          end
          longest_name = longest_name + 2
          return Snacks.picker({
            title = "Workspaces",
            items = items,
            layout = "vscode",
            format = function(item)
              local ret = {}
              ret[#ret + 1] = { ("%-" .. longest_name .. "s"):format(item.name), "SnacksPickerLabel" }
              ret[#ret + 1] = { item.text, "SnacksPickerComment" }
              return ret
            end,
            confirm = function(picker, item)
              picker:close()
              vim.cmd(("WorkspacesOpen %s"):format(item.name))
              vim.cmd("SessionLoad")
            end,
          })
        end, {
          desc = "Workspaces picker",
        })

        vim.keymap.set("n", "<Leader>sP", "<cmd>WorkspacesPicker<cr>", { desc = "Recent workspaces" })
      end,
      config = function()
        require("workspaces").setup()
      end,
    },
  },
}

return M
