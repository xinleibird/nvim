local actions = require("telescope.actions")
local icons = require("core.configs.icons")

local M = {
  defaults = {
    preview = {
      filetype_hook = function(_, bufnr, opts)
        -- don't display jank pdf previews
        if opts.ft == "pdf" then
          require("telescope.previewers.utils").set_preview_message(
            bufnr,
            opts.winid,
            "Not displaying " .. opts.ft
          )
          return false
        end
        return true
      end,
    },
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = " " .. icons.ui.Search .. "  ",
    selection_caret = " " .. icons.ui.Ghost .. "  ",
    entry_prefix = "    ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.80,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = {
      "%.DS_Store",
      "%.git/",
      "^%.DS_Store",
      "^%.bash_history",
      "^%.cache/",
      "^%.cargo/",
      "^%.lemminx/",
      "^%.localized",
      "^%.npm/",
      "^%.nvm/",
      "^%.oh%-my%-zsh/",
      "^%.python_history",
      "^%.redhat",
      "^%.rustup",
      "^%.ssh/",
      "^%.viminfo",
      "^%.vscode%-cli/",
      "^%.vscode/",
      "^%.zcompdump",
      "^%.zsh_sessions/",
      "^%Pictures/",
      "^./.git/",
      "^.git/",
      "^Applications/",
      "^Documents/",
      "^Downloads/",
      "^Icon$",
      "^Library/",
      "^Movies/",
      "^Music/",
      "^Public/",
      "^build/",
      "^dist/",
      "^lazy%-lock%.json$",
      "^node_modules/",
      "^node_modules/",
      "^package%-lock%.json$",
      "^target/",
      "^vendor/",
      "^go%.mod$",
      "^go%.sum$",
      "lock%.json$",
      "mocks$",
      "^tags$",
      "^yarn%.lock$",
      "/doc/.*%.txt$",
    },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      i = {
        ["<D-v>"] = { "<C-r>+", type = "command" },
        ["<C-u>"] = false,

        ["<C-Tab>"] = function(list)
          actions.send_to_loclist(list)
          vim.cmd([[topleft lopen]])
        end,

        ["<C-S-Tab>"] = function(list)
          if list ~= nil then
            actions.send_selected_to_loclist(list)
            vim.cmd([[topleft lopen]])
          end
        end,

        ["<C-q>"] = function(list)
          actions.send_to_qflist(list)
          vim.cmd([[topleft copen]])
        end,

        ["<C-S-q>"] = function(list)
          if list ~= nil then
            actions.send_selected_to_qflist(list)
            vim.cmd([[topleft copen]])
          end
        end,

        ["<M-q>"] = false,
      },
      n = {
        ["<C-Tab>"] = function(list)
          actions.send_to_loclist(list)
          vim.cmd([[topleft lopen]])
        end,

        ["<C-S-Tab>"] = function(list)
          if list ~= nil then
            actions.send_selected_to_loclist(list)
            vim.cmd([[topleft lopen]])
          end
        end,

        ["<C-q>"] = function(list)
          actions.send_to_qflist(list)
          vim.cmd([[topleft copen]])
        end,

        ["<C-S-q>"] = function(list)
          if list ~= nil then
            actions.send_selected_to_qflist(list)
            vim.cmd([[topleft copen]])
          end
        end,

        ["<M-q>"] = false,

        ["q"] = actions.close,
      },
    },
  },

  extensions_list = {
    "fzf",
    "projects",
    "ui-select",
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}

return M
