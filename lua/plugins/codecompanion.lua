local M = {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "echasnovski/mini.diff",
    "j-hui/fidget.nvim",
  },
  init = function()
    vim.keymap.set({ "n" }, "<Leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set("v", "<Leader>aa", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<Leader>ap", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })

    local fidget = require("fidget")
    local handler
    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "CodeCompanionRequest*",
      group = vim.api.nvim_create_augroup("CodeCompanionHooks", {}),
      callback = function(request)
        if request.match == "CodeCompanionRequestStarted" then
          if handler then
            handler.message = "Abort."
            handler:cancel()
            handler = nil
          end
          handler = fidget.progress.handle.create({
            title = "",
            message = "Thinking...",
            lsp_client = { name = "CodeCompanion" },
          })
        elseif request.match == "CodeCompanionRequestFinished" then
          if handler then
            handler.message = "Done."
            handler:finish()
            handler = nil
          end
        end
      end,
    })
  end,
  config = function()
    require("codecompanion").setup({
      opts = {
        -- show_defaults = false,
        log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
        language = "Chinese",
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
