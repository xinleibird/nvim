local M = {
  "zk-org/zk-nvim",
  event = "VeryLazy",
  dependencies = "folke/snacks.nvim",
  init = function()
    vim.keymap.set("n", "<leader>zp", "<cmd>ZkNotes<cr>", { desc = "Zk Notes" })
    vim.keymap.set("n", "<leader>zt", "<cmd>ZkTags<cr>", { desc = "Zk Tags" })
    vim.keymap.set("n", "<leader>zn", "<cmd>ZkNew<cr>", { desc = "Zk New" })
    vim.keymap.set("n", "<leader>zt", function()
      Snacks.picker.grep({ cwd = vim.fn.expand("$HOME") .. "/.notes" })
    end, { desc = "Zk Grep" })
  end,
  config = function()
    require("zk").setup({
      picker = "snacks_picker",
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
