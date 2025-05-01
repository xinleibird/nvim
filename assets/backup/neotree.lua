local M = {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    -- { "3rd/image.nvim", opts = {} }, -- Optional image support in preview window: See `# Preview Mode` for more information
  },

  init = function()
    vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle reveal<CR>")

    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      once = true,
      group = vim.api.nvim_create_augroup("user_enter_alpha_init_neotree_bufferline_custom_areas", { clear = true }),
      command = "Neotree close",
    })
  end,
  config = function()
    local icons = require("configs.icons")

    require("neo-tree").setup({
      nesting_rules = {},
      hide_root_node = true,
      retain_hidden_root_indent = true,
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = "single",
      sort_function = nil, -- use a custom function for sorting files and directories in the tree
      default_component_configs = {
        indent = {
          with_markers = false,
          expander_collapsed = "",
          expander_expanded = "",
        },
        diagnostics = {
          symbols = {
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Info,
            warn = icons.diagnostics.Warn,
            error = icons.diagnostics.Error,
          },
        },
        icon = {
          folder_closed = icons.ui.Folder,
          folder_open = icons.ui.FolderOpen,
          folder_empty = icons.ui.FolderEmpty,
          folder_empty_open = icons.ui.FolderEmptyOpen,
          default = "*",
        },
        modified = {
          symbol = "", --"[+]",
        },
        git_status = {
          symbols = {
            -- Change type
            added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = icons.git.Deleted,
            renamed = icons.git.Renamed,
            -- Status type
            untracked = icons.git.Untracked,
            ignored = icons.git.Ignored,
            unstaged = icons.git.Unstaged,
            staged = icons.git.Staged,
            conflict = "",
          },
        },
      },
      window = {
        width = 27,
        mappings = {
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
        },
      },
      filesystem = {
        filtered_items = {
          hide_by_name = {
            --"node_modules"
          },
          hide_by_pattern = { -- uses glob style patterns
            --"*.meta",
            --"*/src/*/tsconfig.json",
            "Icon*",
          },
        },
        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
        use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
        window = {
          mappings = {
            ["D"] = "trash",
            ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
            ["z"] = "close_node",
            ["Z"] = "close_all_nodes",
            ["/"] = "",
            ["e"] = "",
            ["b"] = "",
            ["s"] = "open_split",
            ["v"] = "open_vsplit",
            ["S"] = "",
          },
        },
        commands = {
          trash = function(state)
            local inputs = require("neo-tree.ui.inputs")
            local node = state.tree:get_node()
            if node.type == "message" then
              return
            end
            local _, name = require("neo-tree.utils").split_path(node.path)
            local msg = string.format("Are you sure you want to trash '%s'?", name)
            inputs.confirm(msg, function(confirmed)
              if not confirmed then
                return
              end
              vim.api.nvim_command("silent !trash " .. node.path)
              require("neo-tree.sources.manager").refresh(state)
            end)
          end,
        },
      },
      -- on_attach = function(bufnr)
      --   vim.keymap.del("n", "<z>", { buffer = bufnr })
      -- end,
      event_handlers = {
        {
          event = "neo_tree_window_before_open",
          handler = function()
            vim.o.showtabline = 2
            vim.o.laststatus = 3
            -- if vim.bo[0].filetype == "snacks_dashboard" then
            --   vim.cmd("bd!")
            -- end
          end,
        },
      },
    })
  end,
}

return M
