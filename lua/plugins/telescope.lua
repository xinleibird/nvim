local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    {
      "nvim-telescope/telescope-ui-select.nvim",
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      event = "BufRead",
    },
  },
  cmd = "Telescope",
  init = function()
    vim.keymap.set("n", "<leader>sP", "<cmd>Telescope projects<CR>", { desc = "Recent projects" })

    vim.keymap.set("n", "<leader>sp", "<cmd>Telescope find_files<cr>", { desc = "Files" })

    vim.keymap.set(
      "n",
      "<leader>sa",
      "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
      { desc = "Files include ignored and hidden" }
    )

    vim.keymap.set("n", "<leader>st", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })

    vim.keymap.set("n", "<leader>sc", "<cmd>Telescope grep_string<CR>", { desc = "Text under cursor" })

    vim.keymap.set("v", "<leader>sc", "<cmd>Telescope grep_string<CR>", { desc = "Text visual selected" })

    vim.keymap.set("n", "<leader>sb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })

    vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<CR>", { desc = "Help pages" })

    vim.keymap.set("n", "<leader>sr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })

    vim.keymap.set(
      "n",
      "<leader>sz",
      "<cmd>Telescope current_buffer_fuzzy_find<CR>",
      { desc = "Current buffer" }
    )

    vim.keymap.set("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0 <CR>", { desc = "Buf diagnostic" })

    vim.keymap.set("n", "<leader>lw", "<cmd>Telescope diagnostics<CR>", { desc = "Workspace diagnostic" })
  end,
  opts = function()
    local actions = require("telescope.actions")
    local icons = require("configs.icons")
    return {
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
            results_width = 0.9,
          },
          vertical = {
            mirror = false,
          },
          width = 0.90,
          height = 0.90,
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
            ["<D-v>"] = { "<C-r>+", type = "command" }, -- yank (paste) text
            ["<C-u>"] = false,

            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,

            ["<C-S-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

            ["<C-tab>"] = actions.send_to_loclist + actions.open_loclist,

            ["<C-S-tab>"] = actions.send_selected_to_loclist + actions.open_loclist,

            ["<M-q>"] = false,
          },
          n = {
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,

            ["<C-S-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

            ["<C-tab>"] = actions.send_to_loclist + actions.open_loclist,

            ["<C-S-tab>"] = actions.send_selected_to_loclist + actions.open_loclist,

            ["<M-q>"] = false,

            ["q"] = actions.close,
          },
        },
      },
      extensions_list = {
        "fzf",
        "projects",
        "ui-select",
        "todo-comments",
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
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    -- load extensions
    for _, ext in ipairs(opts.extensions_list or {}) do
      telescope.load_extension(ext)
    end
  end,
}

return M
