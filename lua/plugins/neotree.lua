local M = {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    -- { "3rd/image.nvim", opts = {} }, -- Optional image support in preview window: See `# Preview Mode` for more information
    {
      "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },

  init = function()
    -- vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>")
    vim.keymap.set("n", "<leader>e", "<Cmd>Neotree reveal<CR>")

    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      once = true,
      group = vim.api.nvim_create_augroup(
        "user_enter_alpha_init_neotree_bufferline_custom_areas",
        { clear = true }
      ),
      command = "Neotree close",
    })

    -- If you want icons for diagnostic errors, you'll need to define them somewhere:
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵 ", texthl = "DiagnosticSignHint" })
  end,
  config = function()
    local icons = require("configs.icons")

    -- Trash the target
    local inputs = require("neo-tree.ui.inputs")
    local function trash(state)
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
    end

    require("neo-tree").setup({
      nesting_rules = {},
      -- hide_root_node = true,
      -- retain_hidden_root_indent = true,

      close_if_last_window = true,
      popup_border_style = "single",
      sort_function = nil,

      default_component_configs = {
        indent = {
          with_markers = false,
          with_expanders = true,
        },
        icon = {
          folder_closed = icons.ui.Folder,
          folder_open = icons.ui.FolderOpen,
          folder_empty = icons.ui.FolderEmpty,
          folder_empty_open = icons.ui.FolderEmptyOpen,
        },
        modified = {
          symbol = "", -- (default "[+]")
        },
        git_status = {
          symbols = {
            deleted = icons.git.Deleted,
            renamed = icons.git.Renamed,
            untracked = icons.git.Untracked,
            ignored = icons.git.Ignored,
            unstaged = icons.git.Unstaged,
            staged = icons.git.Staged,
          },
        },
      },

      window = {
        width = 30,
        mappings = {
          P = {
            "toggle_preview",
            config = { use_float = true, use_image_nvim = false },
          },
        },
      },

      filesystem = {
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            D = "trash",
          },
        },
        commands = {
          trash = trash,
        },
      },

      buffers = {
        show_unloaded = true,
      },
    })
  end,
}

return M
