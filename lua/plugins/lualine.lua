local M = {
  "nvim-lualine/lualine.nvim",
  event = "ColorScheme",
  dependencies = "echasnovski/mini.diff",
  opts = function()
    local function visualed()
      local mode = vim.api.nvim_get_mode().mode
      return mode == "V"
        or mode == "Vs"
        or mode == "v"
        or mode == "vs"
        or mode == "CTRL-V"
        or mode == "\16"
        or mode == "\19"
        or mode == "\22"
        or mode == "\22s"
        or mode == "s"
        or mode == "S"
    end

    local function stbufnr()
      return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
    end

    local function diff_source()
      local minidiff_summary = vim.b[stbufnr()].minidiff_summary

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
        "mode",
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
            return icons.ui.Ghost .. "  " .. string.format("%-8s", mode)
          end

          return icons.ui.GhostOutline .. "  " .. string.format("%-8s", mode)
        end,
        separator = { left = "", right = "" },
        padding = { left = 0, right = 0 },
      },

      cwd = {
        "mode",
        fmt = function()
          local cwd_tail = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

          return icons.ui.Path .. " " .. cwd_tail
        end,
        separator = { left = "" },
        padding = { left = 0, right = 1 },
      },

      branch = {
        "branch",
        icon = icons.ui.Branch,
        padding = { left = 2, right = 0 },
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

          local modified = vim.bo[stbufnr()].modified
          local modifiable = vim.bo[stbufnr()].modifiable

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
        file_status = false,
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
        icon = icons.ui.ArrowClosed .. "  " .. icons.ui.GitCompare .. " ",
        cond = nil,
      },

      diagnostics = {
        "diagnostics",
        icon = icons.ui.ArrowClosed .. "  " .. icons.ui.BugOutline .. " ",
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

      lsp = {
        "lsp",
        fmt = function()
          if not rawget(vim, "lsp") then
            return ""
          end

          local client_batch = ""
          local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })

          for _, client in ipairs(clients) do
            if client.attached_buffers[stbufnr()] and client.name ~= "null-ls" then
              client_batch = client_batch .. client.name .. " "
            end
          end

          local formatter_batch = ""
          local formatters = {}
          local conform_ok, conform = pcall(require, "conform")
          if conform_ok then
            formatters = conform.list_formatters_for_buffer(0)
          end

          for _, formatter in ipairs(formatters) do
            formatter_batch = formatter_batch .. formatter .. " "
          end

          local linter_batch = ""
          local linters = require("lint")._resolve_linter_by_ft(vim.bo.ft)

          for _, linter in ipairs(linters) do
            linter_batch = linter_batch .. linter .. " "
          end

          if client_batch == "" and formatter_batch == "" and linter_batch == "" then
            return ""
          end

          return (
            ""
            .. (client_batch == "" and "" or (icons.ui.Protocol .. " " .. client_batch .. " "))
            .. (formatter_batch == "" and "" or (icons.ui.Formatter .. " " .. formatter_batch .. " "))
            .. (linter_batch == "" and "" or (icons.ui.Linter .. " " .. linter_batch .. " "))
            .. icons.ui.ChevronLeft
          )
        end,
        padding = { left = 2, right = 2 },
      },

      filetype = {
        "filetype",
        padding = { left = 0, right = 1 },
        icon_only = true,
      },

      location = {
        "location",
        fmt = function()
          if visualed() then
            local starts = vim.fn.line("v")
            local ends = vim.fn.line(".")
            local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
            return "󰩭"
              .. string.format("%5d", tostring(vim.fn.wordcount().visual_chars))
              .. ":"
              .. string.format("%-4d", tostring(lines))
              .. "󱃨"
          end

          return "󰼂%5l:%-4c󰼁"
        end,
        -- selectionCount,
        separator = { left = "", right = "" },
        padding = { left = 0, right = 0 },
      },

      progress = {
        "progress",
        separator = { left = "", right = "" },
        padding = { left = 1, right = 0 },
      },
    }

    return {
      options = {
        component_separators = "",
        -- for catppuccin colorscheme
        theme = "catppuccin",
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          components.sep,
          components.mode,
          components.sep,
          components.cwd,
        },
        lualine_b = {
          components.filename,
        },
        lualine_c = {
          components.branch,
          components.diff,
          components.diagnostics,
          "%=",
        },
        lualine_x = {
          components.lsp,
          components.filetype,
        },
        lualine_y = {
          components.location,
        },
        lualine_z = {
          components.progress,
          components.sep,
        },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
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
