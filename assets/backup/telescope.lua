local M = {
  "nvim-telescope/telescope.nvim",
  event = "UIEnter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope-ui-select.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "natecraddock/workspaces.nvim",
      config = function()
        -- returns true if `dir` is a child of `parent`
        local is_dir_in_parent = function(dir, parent)
          if parent == nil then
            return false
          end
          local ws_str_find, _ = string.find(dir, parent, 1, true)
          if ws_str_find == 1 then
            return true
          else
            return false
          end
        end

        -- convenience function which wraps is_dir_in_parent with active file
        -- and workspace.
        local current_file_in_ws = function()
          local workspaces = require("workspaces")
          local ws_path = require("workspaces.util").path
          local current_ws = workspaces.path()
          local current_file_dir = ws_path.parent(vim.fn.expand("%:p", true))

          return is_dir_in_parent(current_file_dir, current_ws)
        end

        -- set workspace when changing buffers
        local group = vim.api.nvim_create_augroup("user_workspace_group", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
          group = group,
          callback = function()
            -- do nothing if not file type
            local buf_type = vim.api.nvim_get_option_value("buftype", { buf = 0 })
            if buf_type ~= "" and buf_type ~= "acwrite" then
              return
            end

            -- do nothing if already within active workspace
            if current_file_in_ws() then
              return
            end

            local workspaces = require("workspaces")
            local ws_path = require("workspaces.util").path
            local current_file_dir = ws_path.parent(vim.fn.expand("%:p", true))

            -- filtered_ws contains workspace entries that contain current file
            local filtered_ws = vim.tbl_filter(function(entry)
              return is_dir_in_parent(current_file_dir, entry.path)
            end, workspaces.get())

            -- select the longest match
            local selected_workspace = nil
            for _, value in pairs(filtered_ws) do
              if not selected_workspace then
                selected_workspace = value
              end
              if string.len(value.path) > string.len(selected_workspace.path) then
                selected_workspace = value
              end
            end

            if selected_workspace then
              workspaces.open(selected_workspace.name)
            end
          end,
        })

        -- use below example if using any `open` hooks, such as telescope, otherwise
        -- the hook will run every time when switching to a buffer from a different
        -- workspace.

        require("workspaces").setup({
          hooks = {
            open = {
              -- -- do not run hooks if file already in active workspace
              -- function()
              --   if current_file_in_ws() then
              --     return false
              --   end
              -- end,
              --
              -- function()
              --   require("telescope.builtin").find_files()
              -- end,

              function()
                local git_path = vim.uv.cwd() .. "/.git"
                local _, err = vim.uv.fs_stat(git_path)
                vim.g.cwd_is_git = true

                if err then
                  vim.g.cwd_is_git = false
                end
              end,
            },
          },
        })
      end,
    },
  },
  cmd = "Telescope",
  init = function()
    vim.keymap.set("n", "<leader>sP", "<cmd>Telescope workspaces<CR>", { desc = "Recent workspaces" })
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
    vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<CR>", { desc = "Help pages" })
    vim.keymap.set("n", "<leader>sr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
    vim.keymap.set("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Current buffer" })

    vim.keymap.set("n", "<leader>go", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
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
              require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Not displaying " .. opts.ft)
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
        -- file_sorter = require("telescope.sorters").get_fuzzy_file,
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
          "^./.git/",
          "^.git/",
          "Icon",
          "^Pictures/",
          "^Applications/",
          "^Documents/",
          "^Downloads/",
          "^Library/",
          "^Movies/",
          "^Music/",
          "^Public/",
          "^Local/Games/",
          "^build/",
          "^dist/",
          "^lazy%-lock%.json$",
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
          "/nvim/.*%.txt$",
          "^assets/.*",
          "^packages/.*%.vim$",
          "^packages/.*%.lua$",
          ".*%.norg$",
          ".*%.png$",
          ".*%.jpg$",
          ".*%.jpeg$",
          ".*%.gif$",
          ".*%.webp$",
          ".*%.avif$",
          ".*%.pdf$",
        },
        -- generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
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
            ["<C-q>"] = function(prompt_bufnr)
              vim.cmd("cexpr([])")
              actions.send_to_qflist(prompt_bufnr)
              vim.cmd("Trouble qflist open focus=true")
            end,

            ["<C-S-q>"] = function(prompt_bufnr)
              vim.cmd("cexpr([])")
              actions.send_selected_to_qflist(prompt_bufnr)
              vim.cmd("Trouble qflist open focus=true")
            end,

            ["<C-tab>"] = function(prompt_bufnr)
              vim.cmd("cexpr([])")
              actions.send_to_loclist(prompt_bufnr)
              vim.cmd("Trouble loclist open focus=true")
            end,

            ["<C-S-tab>"] = function(prompt_bufnr)
              vim.cmd("cexpr([])")
              actions.send_selected_to_loclist(prompt_bufnr)
              vim.cmd("Trouble loclist open focus=true")
            end,
            ["<M-q>"] = false,
          },
          n = {
            ["<C-q>"] = function(prompt_bufnr)
              vim.cmd("cexpr([])")
              actions.send_to_qflist(prompt_bufnr)
              vim.cmd("Trouble qflist open focus=true")
            end,

            ["<C-S-q>"] = function(prompt_bufnr)
              vim.cmd("cexpr([])")
              actions.send_selected_to_qflist(prompt_bufnr)
              vim.cmd("Trouble qflist open focus=true")
            end,

            ["<C-tab>"] = function(prompt_bufnr)
              vim.cmd("cexpr([])")
              actions.send_to_loclist(prompt_bufnr)
              vim.cmd("Trouble loclist open focus=true")
            end,

            ["<C-S-tab>"] = function(prompt_bufnr)
              vim.cmd("cexpr([])")
              actions.send_selected_to_loclist(prompt_bufnr)
              vim.cmd("Trouble loclist open focus=true")
            end,

            ["<M-q>"] = false,

            ["q"] = actions.close,
          },
        },
      },
      extensions_list = {
        "fzf",
        "workspaces",
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
        workspaces = {
          keep_insert = false,
          path_hl = "String",
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
