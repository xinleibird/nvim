local icons = require("core.configs.icons")

local M = {
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  respect_buf_cwd = false,
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  filters = {
    -- ignored folders and files
    -- dotfiles = false,
    custom = {
      "^Icon[\r\r]$",
      "^Network Trash Folder",
      "^Temporary Items",
      "^\\.AppleDB",
      "^\\.AppleDesktop",
      "^\\.AppleDouble",
      "^\\.CFUserTextEncoding",
      "^\\.DS_Store",
      "^\\.DocumentRevisions-V100",
      "^\\.Spotlight-V100",
      "^\\.TemporaryItems",
      "^\\.Trashes",
      "^\\.VolumeIcon.icns",
      "^\\.apdisk",
      "^\\.com.apple.timemachine.donotpresent",
      "^\\.fseventsd",
      "^\\.git$",
      "^\\.github$",
      "^\\.vscode$",
      "^node_modules",
    },
    -- exclude = {
    --   ".json",
    -- },
  },
  git = {
    enable = true,
    ignore = true,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = icons.diagnostics.Hint,
      info = icons.diagnostics.Info,
      warning = icons.diagnostics.Warning,
      error = icons.diagnostics.Error,
    },
  },
  view = {
    adaptive_size = false,
    side = "left",
    width = 30,
    preserve_window_proportions = true,
  },
  filesystem_watchers = {
    enable = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    -- root_folder_label = true,
    root_folder_label = function(path)
      return icons.ui.FolderOpen .. " " .. vim.fn.fnamemodify(path, ":t")
    end,
    highlight_git = true,
    -- highlight_opened_files = "none",

    indent_markers = {
      enable = false,
    },
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      git_placement = "after",
      glyphs = {
        default = icons.ui.File,
        symlink = icons.ui.FileSymlink,
        folder = {
          default = icons.ui.Folder,
          empty = icons.ui.FolderEmpty,
          open = icons.ui.FolderOpen,
          empty_open = icons.ui.FolderEmptyOpen,
          symlink = icons.ui.FolderSymlink,
          symlink_open = icons.ui.FolderSymlinkOpen,
          arrow_open = icons.ui.ArrowOpen,
          arrow_closed = icons.ui.ArrowClosed,
        },
        git = {
          unstaged = icons.git.Unstaged,
          staged = icons.git.Staged,
          unmerged = icons.git.Unmerged,
          renamed = icons.git.Renamed,
          untracked = icons.git.Untracked,
          deleted = icons.git.Deleted,
          ignored = icons.git.Ignored,
        },
      },
    },
  },

  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.del("n", "<C-e>", { buffer = bufnr })
    vim.keymap.del("n", "<C-k>", { buffer = bufnr })
    vim.keymap.del("n", "<C-r>", { buffer = bufnr })
    vim.keymap.del("n", "c", { buffer = bufnr })
    vim.keymap.del("n", "e", { buffer = bufnr })
    vim.keymap.del("n", "u", { buffer = bufnr })
    vim.keymap.del("n", "ge", { buffer = bufnr })
    vim.keymap.del("n", "o", { buffer = bufnr })
    vim.keymap.del("n", "O", { buffer = bufnr })
    vim.keymap.del("n", "gy", { buffer = bufnr })
    vim.keymap.del("n", "y", { buffer = bufnr })
    vim.keymap.del("n", "Y", { buffer = bufnr })
    vim.keymap.del("n", "<2-RightMouse>", { buffer = bufnr })

    vim.keymap.set(
      "n",
      "<C-r>",
      api.fs.rename_full,
      { desc = "nvim-tree: Rename: Full Path", buffer = bufnr, noremap = true, silent = true, nowait = true }
    )

    vim.keymap.set(
      "n",
      "y",
      api.fs.copy.node,
      { desc = "nvim-tree: Copy", buffer = bufnr, noremap = true, silent = true, nowait = true }
    )

    -- vim.keymap.set("n", "<Esc>", api.tree.close, { desc = "Close" })
  end,
}

return M
