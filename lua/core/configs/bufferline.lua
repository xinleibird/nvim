local icons = require("core.configs.icons")

-- local function diagnostics_indicator(_, level)
--   local icon = " "
--
--   if level:match("error") then
--     icon = icons.diagnostics.Error
--   end
--   if level:match("warn") then
--     icon = icons.diagnostics.Warning
--   end
--   if level:match("info") then
--     icon = icons.diagnostics.Info
--   end
--   if level:match("hint") then
--     icon = icons.diagnostics.Hint
--   end
--
--   return " " .. icon
-- end

-- local function diagnostics_indicator(_, _, diagnostics, _)
--   local symbols = {
--     error = icons.diagnostics.Error,
--     warning = icons.diagnostics.Warning,
--     info = icons.diagnostics.Info,
--     hint = icons.diagnostics.Hint,
--   }
--
--   local errors = ""
--   local warnings = ""
--   local infos = ""
--   local hints = ""
--
--   for name, count in pairs(diagnostics) do
--     if name == "error" then
--       errors = symbols[name] .. " " .. count .. " "
--     end
--     if name == "warning" then
--       warnings = symbols[name] .. " " .. count .. " "
--     end
--     if name == "info" then
--       infos = symbols[name] .. " " .. count .. " "
--     end
--     if name == "hint" then
--       hints = symbols[name] .. " " .. count .. " "
--     end
--   end
--
--   return errors .. warnings .. infos .. hints
-- end

local function is_ft(b, ft)
  return vim.bo[b].filetype == ft
end

local function custom_filter(bufnr, buf_nums)
  local exclude_ft = { "qf", "fugitive", "git", "dirvish", "toggleterm", "" }
  local cur_ft = vim.bo[bufnr].filetype
  local should_show = not vim.tbl_contains(exclude_ft, cur_ft)

  if not should_show then
    return false
  end

  local logs = vim.tbl_filter(function(b)
    return is_ft(b, "log")
  end, buf_nums or {})
  if vim.tbl_isempty(logs) then
    return true
  end
  local tab_num = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr("$")
  local is_log = is_ft(bufnr, "log")
  if last_tab == 1 then
    return true
  end
  -- only show log buffers in secondary tabs
  return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
end

local ok, catppuccin_integrations = pcall(require, "catppuccin.groups.integrations.bufferline")
local M = {
  highlights = ok and catppuccin_integrations.get() or {},
  options = {
    mode = "buffers", -- set to "tabs" to only show tabpages instead
    numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
    close_command = function(bufnr) -- can be a string | function, see "Mouse actions"
      require("utils").buf_kill("bd", bufnr, false)
    end,
    right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
    left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
    middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"

    indicator = {
      icon = "▎", -- ▎default |this should be omitted if indicator style is not 'icon'
      style = "icon", -- can also be 'underline'|'none'|'icon',
      -- style = "underline", -- can also be 'underline'|'none'|'icon',
    },
    -- can also be a table containing 2 custom separators
    -- separator_style = "slant" | "slope" | "padded_slope" | "thick" | "thin" | { 'any', 'any' },
    -- | [focused and unfocused]. eg: { '|', '|' }
    separator_style = "thin",

    buffer_close_icon = icons.ui.Close,
    close_icon = icons.ui.CloseBold,
    modified_icon = icons.ui.Modified,
    left_trunc_marker = icons.ui.ArrowLeft,
    right_trunc_marker = icons.ui.ArrowRight,

    color_icons = true, -- whether or not to add the filetype icon highlights
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = false,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    hover = {
      enabled = false, -- requires nvim 0.8+
      delay = 200,
      reveal = { "close" },
    },
    sort_by = "id",

    --- name_formatter can be used to change the buffer's label in the bufferline.
    --- Please note some names can/will break the
    --- bufferline so use this at your discretion knowing that it has
    --- some limitations that will *NOT* be fixed.
    name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
      -- remove extension from markdown files for example
      ---@diagnostic disable: undefined-field
      if buf.name:match("%.md") then
        return vim.fn.fnamemodify(buf.name, ":t:r")
      end

      return buf.name or ""
    end,
    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    truncate_names = false, -- whether or not tab names should be truncated
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    -- diagnostics_indicator = diagnostics_indicator,
    diagnostics_indicator = nil,
    -- NOTE: this will be called a lot so don't do any heavy processing here
    custom_filter = custom_filter,
    custom_areas = {
      right = function()
        local result = {}

        local clock =
          { text = " " .. icons.ui.Clock .. " " .. vim.fn.strftime("%H:%M") .. " ", link = "@text.warning" }
        table.insert(result, clock)

        local tree_ok, api = pcall(require, "nvim-tree.api")
        if tree_ok then
          if api.tree.is_visible() then
            table.insert(result, { text = " " .. icons.ui.DockLeft .. " ", link = "@text" })
          else
            table.insert(result, { text = " " .. icons.ui.DockLeft .. " ", link = "@comment" })
          end
        end

        if require("utils").any_qf_lc_open() then
          table.insert(result, { text = " " .. icons.ui.DockTop .. " ", link = "@text" })
        else
          table.insert(result, { text = " " .. icons.ui.DockTop .. " ", link = "@comment" })
        end

        if require("utils").any_terminal_open() then
          table.insert(result, { text = " " .. icons.ui.DockBottom .. " ", link = "@text" })
        else
          table.insert(result, { text = " " .. icons.ui.DockBottom .. " ", link = "@comment" })
        end

        local outline_ok, outline = pcall(require, "outline")
        if outline_ok then
          if outline.is_open() then
            table.insert(result, { text = " " .. icons.ui.DockRight .. " ", link = "@text" })
          else
            table.insert(result, { text = " " .. icons.ui.DockRight .. " ", link = "@comment" })
          end
        end

        return result
      end,
    },

    offsets = {
      {
        filetype = "undotree",
        text = "Undotree",
        highlight = "PanelHeading",
        padding = 0,
      },
      {
        filetype = "NvimTree",
        text = "Explorer",
        -- text_align = "left",
        highlight = "PanelHeading",
        padding = 0,
        -- separator = true, -- use a "true" to enable the default, or set your own character
      },
      {
        filetype = "DiffviewFiles",
        text = "Diff View",
        highlight = "PanelHeading",
        padding = 0,
      },
      {
        filetype = "flutterToolsOutline",
        text = "Flutter Outline",
        highlight = "PanelHeading",
      },
      {
        filetype = "lazy",
        text = "Lazy",
        highlight = "PanelHeading",
        padding = 0,
      },
      {
        filetype = "mason",
        text = "Mason",
        highlight = "PanelHeading",
        padding = 0,
      },
    },
  },
}

local function init()
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("user_start_clock_timmer", { clear = true }),
    callback = function()
      vim.fn.timer_start((60 - vim.fn.strftime("%S")) * 1000, function()
        vim.opt_local.ro = vim.opt_local.ro

        vim.fn.timer_start(60 * 1000, function()
          vim.opt_local.ro = vim.opt_local.ro
        end, { ["repeat"] = -1 })
      end, { ["repeat"] = 1 })
    end,
  })

  return M
end

return init()
