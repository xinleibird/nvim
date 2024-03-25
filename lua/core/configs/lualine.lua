local icons = require("core.configs.icons")

local function selected()
  local mode = vim.fn.mode()
  return mode == "V"
    or mode == "Vs"
    or mode == "v"
    or mode == "vs"
    or mode == "CTRL-V"
    or mode == "\22"
    or mode == "\22s"
    or mode == "s"
    or mode == "S"
    or mode == "\19"
end

local function stbufnr()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

local function diff_source()
  if not vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status then
    return ""
  end
  local git_status = vim.b[stbufnr()].gitsigns_status_dict

  if git_status then
    local added = (git_status.added and git_status.added ~= 0) and git_status.added or 0
    local changed = (git_status.changed and git_status.changed ~= 0) and git_status.changed or 0
    local removed = (git_status.removed and git_status.removed ~= 0) and git_status.removed or 0

    return {
      added = added,
      modified = changed,
      removed = removed,
    }
  end
end

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
        return icons.ui.Ghost .. " " .. string.format("%-7s", mode)
      end

      return icons.ui.GhostOutline .. " " .. string.format("%-7s", mode)
    end,
    separator = { left = " ", right = "" },
    padding = { left = 0, right = 0 },
  },

  cwd = {
    "mode",
    fmt = function()
      local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

      if vim.g.cwd_is_git then
        return icons.ui.GitFolderSign .. " " .. cwd
      end

      return icons.ui.Path .. " " .. cwd
    end,
    separator = { left = "" },
    padding = { left = 0, right = 1 },
  },

  branch = {
    "branch",
    icon = icons.ui.Branch,
    padding = { left = 1, right = 0 },
  },

  filename = {
    "filename",
    fmt = function(filename)
      if filename:match("NvimTree_") then
        filename = "NvimTree"
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
      warn = icons.diagnostics.Warning .. " ",
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
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })

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
      local isVisual = selected()
      if isVisual then
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
    separator = { left = "", right = " " },
    padding = { left = 0, right = 0 },
  },

  progress = {
    "progress",
    separator = { left = "", right = " " },
    padding = { left = 0, right = 0 },
  },
}

local M = {
  options = {
    -- disabled_filetypes = { statusline = { "alpha" } },
    -- section_separators = { left = "", right = "" },
    -- component_separators = { left = "", right = "" },
    component_separators = "",
    theme = "catppuccin",
    globalstatus = true,
  },
  sections = {
    lualine_a = {
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

local function init()
  vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
    group = vim.api.nvim_create_augroup("user_detect_git_when_dir_changed", { clear = true }),
    callback = function()
      local git_path = vim.loop.cwd() .. "/.git"
      local _, err = vim.loop.fs_stat(git_path)
      vim.g.cwd_is_git = true

      if err then
        vim.g.cwd_is_git = false
      end
    end,
  })

  return M
end

return init()
