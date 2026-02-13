local M = {
  "zk-org/zk-nvim",
  event = "VeryLazy",
  dependencies = "folke/snacks.nvim",
  init = function()
    local function zk_grep()
      local snacks = require("snacks")
      local util = require("zk.util")
      local notebook_path = util.resolve_notebook_path(0)
      local handle = io.popen("zk list --format json")
      if not handle then
        return
      end
      local result = handle:read("*a")
      handle:close()
      local title_map = {}
      local decoded = vim.fn.json_decode(result)
      for _, note in ipairs(decoded) do
        title_map[note.absPath] = note.title or note.filename
      end
      snacks.picker.grep({
        dirs = { notebook_path },
        prompt = "Zk Grep ❯ ",
        format = function(item, _)
          local title = title_map[item.file] or vim.fn.fnamemodify(item.file, ":t")
          local ret = {}
          table.insert(ret, { "󰠮 ", "SnacksPickerIcon" })
          table.insert(ret, { string.format("%-20s", title), "SnacksPickerLabel" })
          return ret
        end,
      })
    end
    vim.api.nvim_create_user_command("ZkGrep", zk_grep, { desc = "Search text in zk notes using snacks.nvim" })

    vim.keymap.set("n", "<leader>zp", "<cmd>ZkNotes<cr>", { desc = "Zk Notes" })
    vim.keymap.set("n", "<leader>zT", "<cmd>ZkTags<cr>", { desc = "Zk Tags" })
    vim.keymap.set("n", "<leader>zn", "<cmd>ZkNew<cr>", { desc = "Zk New" })
    vim.keymap.set("n", "<leader>zt", "<cmd>ZkGrep<cr>", { desc = "Zk Grep" })
  end,
  config = function()
    require("zk").setup({
      picker = "snacks_picker",
      highlight = {
        additional_vim_regex_highlighting = { "markdown" },
      },
      picker_options = {
        snacks_picker = {
          layout = {
            preset = "default",
          },
        },
      },
    })
  end,
}

return M
