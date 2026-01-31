local M = {
  "nvim-lualine/lualine.nvim",
  event = { "BufRead", "User SnacksDashboardClosed" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.diff",
  },
  opts = function()
    local function get_statusline_bufnr()
      return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
    end

    local function diff_source()
      local minidiff_summary = vim.b[get_statusline_bufnr()].minidiff_summary

      if minidiff_summary then
        local added = (minidiff_summary.add and minidiff_summary.add ~= 0) and minidiff_summary.add or 0
        local changed = (minidiff_summary.change and minidiff_summary.change ~= 0) and minidiff_summary.change or 0
        local removed = (minidiff_summary.delete and minidiff_summary.delete ~= 0) and minidiff_summary.delete or 0

        return {
          added = added,
          modified = changed,
          removed = removed,
        }
      end
    end

    local icons = require("configs.icons")

    local components = {
      sep = {
        "",
        fmt = function()
          return " "
        end,
        padding = { left = 0, right = 0 },
        color = { bg = "None" },
      },

      mode = {
        "mode",
        fmt = function(mode)
          if mode == "NORMAL" then
            return icons.ui.Ghost
          end

          return icons.ui.GhostOutline
        end,
        separator = { left = "", right = "" },
        padding = { left = 0, right = 0 },
      },

      cwd = {
        "mode",
        fmt = function()
          local cwd_tail = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

          return icons.ui.FolderOpen .. " " .. cwd_tail
        end,
        separator = { left = "" },
        padding = { left = 0, right = 1 },
        color = { gui = "" },
      },

      filename = {
        "filename",
        fmt = function(filename)
          if filename:find("filesystem") then
            filename = "NeoTree"
          end

          if filename:match("OUTLINE_") then
            filename = "Outline"
          end

          if filename:match("#toggleterm#") then
            filename = "ToggleTerm"
          end

          local modified = vim.bo[get_statusline_bufnr()].modified
          local modifiable = vim.bo[get_statusline_bufnr()].modifiable

          if not modifiable then
            return icons.ui.Lock .. " " .. filename
          end

          if modified then
            return icons.ui.FileOutline .. " " .. filename .. icons.ui.Modified
          end

          return icons.ui.FileOutline .. " " .. filename .. " "
        end,
        separator = { left = "", right = "" },
        padding = { left = 0, right = 0 },
        color = { gui = "italic" },
        file_status = false,
      },

      branch = {
        "branch",
        icon = icons.ui.Branch,
        fmt = function(branch)
          if branch == "" then
            return ""
          end
          return branch
        end,
        padding = { left = 0, right = 0 },
        separator = { left = "", right = "" },
      },

      diff = {
        "diff",
        source = diff_source,
        symbols = {
          added = icons.git.LineAdded .. " ",
          modified = icons.git.LineModified .. " ",
          removed = icons.git.LineRemoved .. " ",
        },
        padding = { left = 2, right = 0 },
        cond = nil,
      },

      diagnostics = {
        "diagnostics",
        icon = icons.ui.ArrowClosed .. " ",
        padding = { left = 2, right = 0 },
        sources = { "nvim_diagnostic" },
        symbols = {
          error = icons.diagnostics.Error .. " ",
          warn = icons.diagnostics.Warn .. " ",
          info = icons.diagnostics.Info .. " ",
          hint = icons.diagnostics.Hint .. " ",
        },
        -- cond =
      },

      lsp_clients_formatters_linters = {
        "lsp",
        fmt = function()
          local lsp_icon_map = {
            bashls = "",
            cssls = "",
            emmet_language_server = "",
            eslint = "",
            html = "",
            jsonls = "",
            lua_ls = "󰢱",
            marksman = "",
            ["render-markdown"] = "",
            rust_analyzer = "",
            svelte = "",
            tailwindcss = "",
            ts_ls = "",
            ["typescript-tools"] = "",
            vimls = "",
            vtsls = "",
            vue_ls = "",
            zk = "󰰷",
            yamlls = "",
          }
          local client_batch = ""
          local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
          for _, client in ipairs(clients) do
            if client.attached_buffers[get_statusline_bufnr()] and client.name ~= "null-ls" then
              client_batch = client_batch .. (lsp_icon_map[client.name] or "")
            end
          end

          local formatter_icon_map = {
            prettier = "",
            shfmt = "",
            stylua = "",
          }
          local formatter_batch = ""
          local formatters = {}
          local conform_ok, conform = pcall(require, "conform")
          if conform_ok then
            formatters = conform.list_formatters_for_buffer(0)
          end

          for _, formatter in ipairs(formatters) do
            formatter_batch = formatter_batch .. (formatter_icon_map[formatter] or "")
          end

          local linter_icon_map = {
            htmlhint = "",
            shellcheck = "",
          }
          local linter_batch = ""
          local lint_ok, lint = pcall(require, "lint")
          local linters = {}
          if lint_ok then
            linters = lint._resolve_linter_by_ft(vim.bo.ft)
          end

          for _, linter in ipairs(linters) do
            linter_batch = linter_batch .. (linter_icon_map[linter] or "")
          end

          return (
            ""
            .. (#clients > 0 and "" or "")
            .. (client_batch == "" and "" or ("" .. client_batch))
            .. (#formatters > 0 and "・" or "")
            .. (formatter_batch == "" and "" or ("" .. formatter_batch))
            .. (#linters > 0 and "・" or "")
            .. (linter_batch == "" and "" or ("" .. linter_batch))
          )
        end,
        padding = { left = 0, right = 0 },
        separator = { left = "", right = "" },
        on_click = function()
          local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
          if #clients == 0 then
            require("snacks").notify.warn("󱐋 No LSP Clients", {
              title = "LSP",
              timeout = 5000,
            })
          else
            local client_names = {}
            for _, client in ipairs(clients) do
              table.insert(client_names, "󱐋 " .. client.name)
            end
            local lsp_message = table.concat(client_names, "\n")
            require("snacks").notify.info(lsp_message, {
              title = "LSP",
              timeout = 5000,
            })
          end

          local formatters = {}
          local conform_ok, conform = pcall(require, "conform")
          if conform_ok then
            formatters = conform.list_formatters_for_buffer(0)
          end
          if #formatters == 0 then
            require("snacks").notify.warn("󰃢 No Formatters", {
              title = "Formatter",
              timeout = 5000,
            })
          else
            local formatter_names = {}
            for _, formatter in ipairs(formatters) do
              table.insert(formatter_names, "󰃢 " .. formatter)
            end
            local formatter_message = table.concat(formatter_names, "\n")
            require("snacks").notify.info(formatter_message, {
              title = "Formatter",
              timeout = 5000,
            })
          end

          local lint_ok, lint = pcall(require, "lint")
          local linters = {}
          if lint_ok then
            linters = lint._resolve_linter_by_ft(vim.bo.ft)
          end
          if #linters == 0 then
            require("snacks").notify.warn("󰦀 No Linters", {
              title = "Linter",
              timeout = 5000,
            })
          else
            local linter_names = {}
            for _, linter in ipairs(linters) do
              table.insert(linter_names, "󰦀 " .. linter)
            end
            local linter_message = table.concat(linter_names, "\n")
            require("snacks").notify.info(linter_message, {
              title = "Linter",
              timeout = 5000,
            })
          end
        end,
      },

      codecompanion = {
        function()
          local ok, codecompanion = pcall(require, "codecompanion")
          if ok then
            local status = codecompanion.last_chat()
            return status and "󰇧" or "󰇨"
          end
          return ""
        end,
        color = function()
          local ok, codecompanion = pcall(require, "codecompanion")
          if ok then
            local status = codecompanion.last_chat()
            return status and "LualineCodeCompanionOpen" or "LualineCodeCompanionClose"
          end
          return "LualineCodeCompanionClose"
        end,
        separator = { left = "", right = "" },
        padding = { left = 0, right = 0 },
      },

      filetype = {
        "filetype",
        padding = { left = 0, right = 0 },
        icon_only = true,
        separator = { left = "" },
        on_click = function()
          require("snacks").notify.info(icons.ui.FileOutline .. " " .. vim.bo[0].filetype, {
            title = "Filetype",
            timeout = 5000,
          })
        end,
      },

      location = {
        "location",
        fmt = function()
          local mode = require("lualine.utils.mode").get_mode()
          if mode == "VISUAL" or mode == "V-LINE" or mode == "V-BLOCK" then
            local starts = vim.fn.line("v")
            local ends = vim.fn.line(".")
            local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
            return "󰩭"
              .. string.format("%4d", tostring(vim.fn.wordcount().visual_chars))
              .. ":"
              .. string.format("%-3d", tostring(lines))
              .. "󱃨"
          end

          return "󰼂%4l:%-3c󰼁"
        end,
        -- selectionCount,
        separator = { left = "", right = "" },
        padding = { left = 0, right = 0 },
      },

      progress = {
        "progress",
        separator = { left = "", right = "" },
        padding = { left = 1, right = 0 },
        color = { gui = "" },
      },
    }

    return {
      options = {
        component_separators = "",
        theme = "catppuccin", -- for catppuccin colorscheme
        globalstatus = true,
        refresh = { -- sets how often lualine should refresh it's contents (in ms)
          statusline = 50, -- The refresh option sets minimum time that lualine tries
        },
      },
      sections = {
        lualine_a = {
          components.sep,
          components.mode,
          components.sep,
          components.cwd,
        },
        lualine_b = {
          components.branch,
        },
        lualine_c = {
          components.diff,
          components.diagnostics,
          "%=",
        },
        lualine_x = {
          components.filetype,
          components.sep,
        },
        lualine_y = {
          components.lsp_clients_formatters_linters,
          components.sep,
          components.codecompanion,
          components.sep,
          components.location,
        },
        lualine_z = {
          components.progress,
        },
      },
      inactive_sections = {},
      tabline = {},
      winbar = {},
      extensions = {},
    }
  end,
  config = function(_, opts)
    require("lualine").setup(opts)
  end,
}

return M
