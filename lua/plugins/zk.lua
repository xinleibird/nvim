local M = {
  "zk-org/zk-nvim",
  lazy = false,
  init = function()
    vim.keymap.set("n", "<leader>zp", "<cmd>ZkNotes<cr>", { desc = "Zk Notes" })
    vim.keymap.set("n", "<leader>zt", "<cmd>ZkTags<cr>", { desc = "Zk Tags" })
    vim.keymap.set("n", "<leader>zn", "<cmd>ZkNew<cr>", { desc = "Zk New" })
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
