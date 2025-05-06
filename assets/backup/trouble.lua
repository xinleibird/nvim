local M = {
  "folke/trouble.nvim",
  event = "BufRead",
  cmd = "Trouble",
  opts = {
    win = {
      wo = {
        fillchars = "",
      },
    },
    modes = {
      -- qflist = { auto_open = true },
    },
  }, -- for default options, refer to the configuration section for custom setup.
  keys = {
    -- {
    --   "<C-q>",
    --   "<cmd>Trouble qflist toggle focus=true<cr>",
    --   desc = "Quickfix List (Trouble)",
    -- },
    -- {
    --   "<C-Tab>",
    --   "<cmd>Trouble loclist toggle focus=true<cr>",
    --   desc = "Location List (Trouble)",
    -- },
    {
      "gr",
      "<cmd>Trouble lsp_references toggle focus=true<cr>",
      desc = "References (Trouble)",
    },
    {
      "gd",
      "<cmd>Trouble lsp_definitions toggle focus=true<cr>",
      desc = "Definitions (Trouble)",
    },
    {
      "gD",
      "<cmd>Trouble lsp_declarations toggle focus=true<cr>",
      desc = "Declarations (Trouble)",
    },
    {
      "gF",
      "<cmd>Trouble lsp_type_definitions toggle focus=true<cr>",
      desc = "Type definitions (Trouble)",
    },
    {
      "gi",
      "<cmd>Trouble lsp_implementations toggle focus=true<cr>",
      desc = "Implementations (Trouble)",
    },
    {
      "go",
      "<cmd>Trouble lsp_incoming_calls toggle focus=true<cr>",
      desc = "Incoming calls (Trouble)",
    },
    {
      "gO",
      "<cmd>Trouble lsp_outgoing_calls toggle focus=true<cr>",
      desc = "Outgoing calls (Trouble)",
    },
    {
      "<Leader>ll",
      "<cmd>Trouble lsp toggle focus=true<cr>",
      desc = "All LSP informations (Trouble)",
    },
    {
      "<leader>ld",
      "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>lD",
      "<cmd>Trouble diagnostics toggle focus=true<cr>",
      desc = "Diagnostics (Trouble)",
    },
  },
}

return M
