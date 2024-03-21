local icons = require("core.configs.icons")
-- local colors = require("lualine.themes.catppuccin")

-- local get_palette = require("catppuccin.utils.lualine")
-- local theme = vim.opt.background == "dark" and "mocha" or "latte"
--
-- local colors = get_palette(theme)

local colors = {
  bg = "#202328",
  fg = "#bbc2cf",
  dark = "#202328",
  gray = "#bbc2cf",
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  purple = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

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
  mode = {
    "mode",
    fmt = function(mode)
      local l_icon = icons.ui.Ghost
      local r_icon = icons.ui.FolderOpen
      if mode ~= "NORMAL" then
        l_icon = icons.ui.GhostOutline
        r_icon = icons.ui.FolderEmptyOpen
      end

      local path = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      return l_icon .. " " .. path .. " " .. r_icon
    end,
    separator = { left = " ", right = "" },
    padding = { left = 0, right = 0 },
  },

  branch = {
    "branch",
    fmt = function(branch)
      return branch
    end,
    -- "b:gitsigns_head",
    icon = icons.ui.Branch,
    separator = { left = "", right = "" },
    padding = { left = 2, right = 1 },
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
        return filename .. icons.ui.Modified
      end
      return filename .. " "
    end,
    icon = icons.ui.FileOutline,
    padding = { left = 2, right = 0 },
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
    padding = { left = 1, right = 0 },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },
    separator = { left = "", right = "" },
    icon = icons.ui.ArrowClosed .. "  " .. icons.ui.GitCompare .. " ",
    cond = nil,
  },

  diagnostics = {
    "diagnostics",
    icon = icons.ui.ArrowClosed .. "  " .. icons.ui.BugOutline .. " ",
    padding = { left = 1, right = 0 },
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

      if client_batch == "" and formatter_batch == "" then
        return ""
      end

      return (
        (client_batch == "" and "" or icons.ui.Protocol)
        .. " "
        .. client_batch
        .. (formatter_batch == "" and "" or icons.ui.Bookshelf)
        .. " "
        .. formatter_batch
        .. " "
        .. icons.ui.ChevronLeft
      )
    end,
    padding = { left = 2, right = 2 },
  },

  filetype = {
    "filetype",
    padding = { left = 1, right = 1 },
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
      components.cwd,
    },
    lualine_b = {
      components.branch,
    },
    lualine_c = {
      components.filename,
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
  extensions = {},
}

return M
