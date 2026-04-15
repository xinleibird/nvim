---@module "lazy"
---@type LazySpec
local M = {
  "nvim-lualine/lualine.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
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
        color = { bg = "None", ctermbg = "None" },
      },
      blank = {
        "",
        fmt = function()
          return " "
        end,
        padding = { left = 0, right = 0 },
        -- color = { bg = "None", ctermbg = "None" },
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

      branch = {
        "branch",
        icon = icons.ui.Branch,
        fmt = function(branch)
          if branch == "" then
            return require("configs.icons").ui.NoEntry
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

      lsp_clients = {
        function()
          return "󰇖"
        end,
        on_click = function()
          local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
          if #clients == 0 then
            vim.notify("✗ ~LSP Clients~", vim.log.levels.WARN, {
              title = "LSP Clients",
              icon = "󰮌",
              timeout = 3000,
              id = "lsp_lualine",
            })
          else
            local client_names = {}
            for _, client in ipairs(clients) do
              table.insert(client_names, " **" .. client.name .. "**")
            end
            local lsp_message = table.concat(client_names, "\n")
            vim.notify(lsp_message, vim.log.levels.INFO, {
              title = "LSP Clients",
              icon = "󰇖",
              timeout = 3000,
              id = "lsp_lualine",
            })
          end
        end,
        color = function()
          local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
          return #clients > 0 and "LualineLspActive" or "LualineLspInactive"
        end,
        padding = { left = 1, right = 0 },
        separator = { left = "", right = "" },
      },

      linters = {
        function()
          return "󰚃"
        end,
        on_click = function()
          local lint_ok, lint = pcall(require, "lint")
          local linters = {}
          if lint_ok then
            linters = lint._resolve_linter_by_ft(vim.bo.ft)
          end

          local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
          if #clients > 0 then
            for _, client in ipairs(clients) do
              if vim.tbl_contains({ "eslint", "oxlint" }, client.name) then
                table.insert(linters, client.name)
              end
            end
          end

          if #linters == 0 then
            vim.notify("✗ ~Linters~", vim.log.levels.WARN, {
              title = "Linter",
              icon = "󰚃",
              timeout = 3000,
              id = "linter_lualine",
            })
          else
            local linter_names = {}
            for _, linter in ipairs(linters) do
              table.insert(linter_names, " **" .. linter .. "**")
            end
            local linter_message = table.concat(linter_names, "\n")
            vim.notify(linter_message, vim.log.levels.INFO, {
              title = "Linter",
              icon = "󰚃",
              timeout = 3000,
              id = "linter_lualine",
            })
          end
        end,
        color = function()
          local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
          if #clients > 0 then
            for _, client in ipairs(clients) do
              if vim.tbl_contains({ "eslint", "oxlint" }, client.name) then
                return "LualineLspActive"
              end
            end
          end
          local ok, lint = pcall(require, "lint")
          if ok then
            local linters = lint._resolve_linter_by_ft(vim.bo.ft)
            return #linters > 0 and "LualineLspActive" or "LualineLspInactive"
          end
          return "LualineLspInactive"
        end,
        padding = { left = 0, right = 0 },
        separator = { left = "", right = "" },
      },

      formatters = {
        function()
          return "󰑌"
        end,
        on_click = function()
          local formatters = {}
          local conform_ok, conform = pcall(require, "conform")
          if conform_ok then
            formatters = conform.list_formatters_for_buffer(0)
          end
          if #formatters == 0 then
            vim.notify("✗ ~Formatters~", vim.log.levels.WARN, {
              title = "Formatter",
              icon = "󱎝",
              timeout = 3000,
              id = "formatter_lualine",
            })
          else
            local formatter_names = {}
            for _, formatter in ipairs(formatters) do
              table.insert(formatter_names, " **" .. formatter .. "**")
            end
            local formatter_message = table.concat(formatter_names, "\n")
            vim.notify(formatter_message, vim.log.levels.INFO, {
              title = "Formatter",
              icon = "󰑌",
              timeout = 3000,
              id = "formatter_lualine",
            })
          end
        end,
        color = function()
          local ok, conform = pcall(require, "conform")
          if ok then
            local formatters = conform.list_formatters_for_buffer(0)
            return #formatters > 0 and "LualineLspActive" or "LualineLspInactive"
          end
          return "LualineLspInactive"
        end,
        padding = { left = 1, right = 0 },
        separator = { left = "", right = "" },
      },

      codecompanion_chat = {
        function()
          return "󰭻"
        end,
        on_click = function()
          local ok, codecompanion = pcall(require, "codecompanion")
          if ok then
            local chat = codecompanion.last_chat()
            if chat then
              local adapter = chat.adapter
              local adapter_name = adapter.formatted_name or adapter.name or "CodeCompanion"
              vim.notify("💬 **" .. adapter_name .. "** Chat OK!", vim.log.levels.INFO, {
                title = "CodeCompanion",
                id = "codecompanion_chat_lualine",
                icon = "󰭻",
                timeout = 3000,
              })
            else
              vim.notify("💬 Chat Mode not Ready!", vim.log.levels.WARN, {
                title = "CodeCompanion",
                id = "codecompanion_chat_lualine",
                icon = "󰭻",
                timeout = 3000,
              })
            end
          else
            vim.notify(require("configs.icons").ui.GhostOutline .. "CodeCompanion Broken!", vim.log.levels.ERROR, {
              title = "CodeCompanion",
              id = "codecompanion_lualine",
              timeout = 3000,
            })
          end
        end,
        color = function()
          local ok, codecompanion = pcall(require, "codecompanion")
          if ok then
            local status = codecompanion.last_chat()
            return status and "LualineCodeCompanionActive" or "LualineCodeCompanionInactive"
          end
          return "LualineCodeCompanionInactive"
        end,
        separator = { left = "", right = "" },
        padding = { left = 0, right = 1 },
      },

      codecompanion_cli = {
        function()
          return ""
        end,
        on_click = function()
          local ok = pcall(require, "codecompanion")
          if ok then
            local cli_session = require("codecompanion.interactions.cli").last_cli()
            if cli_session then
              local cli_name = cli_session.agent.description or cli_session.agent_name
              vim.notify("🤖 **" .. cli_name .. "** CLI OK!", vim.log.levels.INFO, {
                title = "CodeCompanion",
                icon = "",
                id = "codecompanion_cli_lualine",
                timeout = 3000,
              })
            else
              vim.notify("🤖 CLI Mode not Ready!", vim.log.levels.WARN, {
                title = "CodeCompanion",
                icon = "",
                id = "codecompanion_cli_lualine",
                timeout = 3000,
              })
            end
          else
            vim.notify(require("configs.icons").ui.GhostOutline .. "CodeCompanion Broken!", vim.log.levels.ERROR, {
              title = "CodeCompanion",
              id = "codecompanion_lualine",
              timeout = 3000,
            })
          end
        end,
        color = function()
          local ok = pcall(require, "codecompanion")
          if ok then
            local cli_session = require("codecompanion.interactions.cli").last_cli()
            return cli_session and "LualineCodeCompanionActive" or "LualineCodeCompanionInactive"
          end
          return "LualineCodeCompanionInactive"
        end,
        separator = { left = "", right = "" },
        padding = { left = 0, right = 0 },
      },

      filetype = {
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
          local icon = require("nvim-web-devicons").get_icon_by_filetype(filetype, { default = false })
          return icon or ""
        end,
        color = function()
          local color = {}
          local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
          if not devicons_ok then
            color.fg = "None"
          end

          local ok, palettes = pcall(require, "catppuccin.palettes")
          if ok then
            local palette = palettes.get_palette()
            local bufnr = vim.api.nvim_get_current_buf()
            local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
            local _, fg = devicons.get_icon_color_by_filetype(filetype, { default = false })
            if fg == nil then
              fg = palette.overlay0
            end

            color.fg = fg
            color.bg = palette.surface0
          else
            color.bg = "None"
          end

          return color
        end,
        padding = { left = 0, right = 0 },
        separator = { left = "", right = "" },
        on_click = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
          local language = vim.treesitter.language.get_lang(filetype) or filetype

          local parser = vim.treesitter.language.add(language)
          local folds = vim.treesitter.query.get(language, "folds")
          local indents = vim.treesitter.query.get(language, "indents")

          local icon = ""
          local ok, devicons = pcall(require, "nvim-web-devicons")
          if ok then
            icon = devicons.get_icon(vim.fn.expand("%:t"), vim.fn.expand("%:e"), { default = false })
            icon = icon or ""
          end

          local ft = filetype == "" and " ~NO~" or " **" .. filetype .. "**"
          local messages = {
            "Filetype: ",
            icon .. ft,
            " ",
            "Tree-sitter:",
          }
          if parser then
            table.insert(messages, " **parser**")
          else
            table.insert(messages, "✗ ~parser~")
          end
          if folds then
            table.insert(messages, " **folds**")
          else
            table.insert(messages, "✗ ~folds~")
          end
          if indents then
            table.insert(messages, " **indents**")
          else
            table.insert(messages, "✗ ~indents~")
          end

          local message = table.concat(messages, "\n")

          vim.notify(message, vim.log.levels.INFO, {
            title = "Filetype",
            timeout = 3000,
            id = "filetype_lualine",
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
        theme = "catppuccin-nvim", -- for catppuccin colorscheme
        globalstatus = true,
        refresh = { -- sets how often lualine should refresh it's contents (in ms)
          statusline = 50, -- The refresh option sets minimum time that lualine tries
        },
      },
      sections = {
        lualine_a = {
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
          components.blank,
          components.linters,
          components.formatters,
          components.lsp_clients,
          components.blank,
          components.codecompanion_chat,
          components.codecompanion_cli,
          components.blank,
        },
        lualine_y = {
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
