---@module "lazy"
---@type LazySpec
local M = {
  "akinsho/bufferline.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    {
      "tiagovla/scope.nvim",
      config = function()
        require("scope").setup()
      end,
    },
  },
  init = function()
    if vim.v.vim_did_enter == 1 then
      require("utils").start_async_clock()
    else
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        group = vim.api.nvim_create_augroup("user_start_clock_timer", { clear = true }),
        callback = function()
          require("utils").start_async_clock()
        end,
      })
    end

    -- vim.keymap.set("n", "<leader>c", function()
    --   if vim.bo[0].filetype == "snacks_dashboard" then
    --     vim.cmd("bd!")
    --     return
    --   end
    --   if vim.bo[0].filetype == "Outline" or vim.bo[0].filetype == "codecompanion" then
    --     vim.cmd("close")
    --     return
    --   end
    --
    --   local bufnr = vim.api.nvim_get_current_buf()
    --   vim.bo[bufnr].buflisted = false
    --
    --   local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })
    --   if #listed_buffers > 0 then
    --     vim.cmd("BufferLineCyclePrev")
    --   else
    --     vim.cmd("enew")
    --   end
    -- end, { desc = "Close buffer" })

    vim.keymap.set("n", "<leader>c", function()
      if vim.bo[0].filetype == "snacks_dashboard" then
        vim.cmd("bd!")
        return
      end
      if vim.bo[0].filetype == "Outline" or vim.bo[0].filetype == "codecompanion" then
        vim.cmd("close")
        return
      end
      local ok, snacks = pcall(require, "snacks")
      if ok then
        snacks.bufdelete.delete()
        return
      end
      require("utils").buf_kill("bd")
    end, { desc = "Close buffer" })
    vim.keymap.set("n", "<leader>be", "<cmd>enew<CR>", { desc = "New buffer" })
    vim.keymap.set("n", "<leader>bb", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
    vim.keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
    vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close others buffers" })
    vim.keymap.set("n", "<leader>bh", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close left buffers" })
    vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseRight<CR>", { desc = "Close right buffers" })
    vim.keymap.set("n", "<leader>bs", "<cmd>BufferLinePick<CR>", { desc = "Select buffer" })
  end,
  opts = function()
    local icons = require("configs.icons")

    local function is_ft(b, ft)
      return vim.bo[b].filetype == ft
    end

    local function custom_filter(bufnr, buf_nums)
      local exclude_ft = {
        "qf",
        "fugitive",
        "git",
        "dirvish",
        "toggleterm",
        "NeogitStatus",
        "gitcommit",
        "DiffviewFiles",
        "checkhealth",
        "query",
      }
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

    return {
      highlights = require("catppuccin.special.bufferline").get_theme(),
      options = {
        get_element_icon = function(element)
          -- element consists of {filetype: string, path: string, extension: string, directory: string}
          -- This can be used to change how bufferline fetches the icon
          -- for an element e.g. a buffer or a tab.
          -- e.g.
          local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
          return icon, hl
          -- or
          -- local custom_map = {my_thing_ft: {icon = "my_thing_icon", hl}}
          -- return custom_map[element.filetype]
        end,
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
        close_command = function(bufnr) -- can be a string | function, see "Mouse actions"
          -- vim.bo[bufnr].buflisted = false
          local ok, snacks = pcall(require, "snacks")
          if ok then
            snacks.bufdelete.delete(bufnr)
          end
          require("utils").buf_kill("bd", bufnr, false)
        end,
        right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"

        indicator = {
          icon = "▍", -- ▎default |this should be omitted if indicator style is not 'icon'
          style = "icon", -- can also be 'underline'|'none'|'icon',
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
        show_buffer_close_icons = false,
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
        -- NOTE: this will be called a lot so don't do any heavy processing here
        custom_filter = custom_filter,
        custom_areas = {
          right = function()
            local result = {}

            -- clock component
            local clock = {
              text = " " .. icons.ui.Clock .. " " .. require("utils").get_last_time() .. " ",
              link = "@text.warning",
            }
            table.insert(result, clock)

            local sidebar_exists = require("utils").any_sidebar_open()

            if sidebar_exists then
              table.insert(result, { text = " " .. icons.ui.DockLeft .. " ", link = "@text" })
            else
              table.insert(result, { text = " " .. icons.ui.DockLeft .. " ", link = "BufferLineTab" })
            end

            if require("utils").any_qf_lc_open() then
              table.insert(result, { text = " " .. icons.ui.DockTop .. " ", link = "@text" })
            else
              table.insert(result, { text = " " .. icons.ui.DockTop .. " ", link = "BufferLineTab" })
            end

            if require("utils").any_terminal_open() then
              table.insert(result, { text = " " .. icons.ui.DockBottom .. " ", link = "@text" })
            else
              table.insert(result, { text = " " .. icons.ui.DockBottom .. " ", link = "BufferLineTab" })
            end

            local outline_ok, outline = pcall(require, "outline")
            if outline_ok then
              if outline.is_open() then
                table.insert(result, { text = " " .. icons.ui.DockRight .. " ", link = "@text" })
              else
                table.insert(result, { text = " " .. icons.ui.DockRight .. " ", link = "BufferLineTab" })
              end
            end

            return result
          end,
        },

        offsets = {
          {
            filetype = "snacks_layout_box",
            text_align = "left",
            text = "󰙅 Explorer",
            highlight = "Constant",
            padding = 0,
          },
          {
            filetype = "Outline",
            text = "Outline 󰺔",
            highlight = "Constant",
            text_align = "right",
            padding = 1,
          },
        },
      },
    }
  end,

  config = function(_, opts)
    require("bufferline").setup(opts)
  end,
}

return M
