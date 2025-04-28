local M = {
  "olimorris/codecompanion.nvim",
  event = "FileReadPre",
  dependencies = "echasnovski/mini.diff",
  init = function()
    vim.keymap.set({ "n" }, "<Leader>ap", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n" }, "<Leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set("v", "<Leader>av", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
  end,
  config = function()
    require("codecompanion").setup({
      opts = {
        -- show_defaults = false,
        log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
        language = "zh-CN",
      },
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
      },
      adapters = {},
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ", -- Prompt used for interactive LLM calls
          provider = "default", -- default|telescope|mini_pick
          opts = {
            show_default_actions = true, -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
          },
        },
        chat = {
          window = {
            opts = {
              numberwidth = 4,
            },
          },
        },
      },
    })
  end,
}

return M
