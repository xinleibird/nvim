local M = {
  "folke/trouble.nvim",
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
    {
      "<C-q>",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
    {
      "<C-Tab>",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "gr",
      "<cmd>Trouble lsp_references toggle<cr>",
      desc = "References (Trouble)",
    },
    {
      "gd",
      "<cmd>Trouble lsp_definitions toggle<cr>",
      desc = "Definitions (Trouble)",
    },
    {
      "gD",
      "<cmd>Trouble lsp_declarations toggle<cr>",
      desc = "Declarations (Trouble)",
    },
    {
      "gF",
      "<cmd>Trouble lsp_type_definitions toggle<cr>",
      desc = "Type definitions (Trouble)",
    },
    {
      "gi",
      "<cmd>Trouble lsp_implementations toggle<cr>",
      desc = "Implementations (Trouble)",
    },
    {
      "go",
      "<cmd>Trouble lsp_incoming_calls toggle<cr>",
      desc = "Incoming calls (Trouble)",
    },
    {
      "gO",
      "<cmd>Trouble lsp_outgoing_calls toggle<cr>",
      desc = "Outgoing calls (Trouble)",
    },
    {
      "<Leader>ll",
      "<cmd>Trouble lsp toggle<cr>",
      desc = "All LSP informations (Trouble)",
    },
    {
      "<leader>ld",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>lD",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
  },
}

return M
