local M = {
  "kevinhwang91/nvim-bqf",
  -- quickfix preview and other functions
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    {
      "junegunn/fzf",
      build = "./install --bin",
    },
  },
  lazy = true,
  event = { "WinNew" },
  config = function()
    require("bqf").setup({
      auto_enable = true,
      auto_resize_height = true,
      ---@diagnostic disable-next-line: missing-fields
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        ---@diagnostic disable-next-line: unused-local
        should_preview_cb = function(bufnr, qwinid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            -- skip file size greater than 100k
            ret = false
          elseif bufname:match("^fugitive://") then
            -- skip fugitive buffer
            ret = false
          end
          return ret
        end,
      },
      func_map = {
        drop = "o",
        openc = "O",
        split = "<C-x>",
        tabdrop = "<C-t>",
        tabc = "",
        vsplit = "<C-v>",
        ptogglemode = "z,",
        stoggleup = "",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    })
  end,
}

return M
