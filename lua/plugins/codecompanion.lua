local M = {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "echasnovski/mini.diff",
    "j-hui/fidget.nvim",
  },
  init = function()
    vim.keymap.set(
      { "n" },
      "<Leader>aa",
      "<cmd>CodeCompanionChat Toggle<cr>",
      { noremap = true, silent = true, desc = "CodeCompanion Toggle Chat" }
    )
    vim.keymap.set(
      "v",
      "<Leader>aa",
      "<cmd>CodeCompanionChat Add<cr>",
      { noremap = true, silent = true, desc = "CodeCompanion Add" }
    )
    vim.keymap.set(
      { "n", "v" },
      "<Leader>ap",
      "<cmd>CodeCompanionActions<cr>",
      { noremap = true, silent = true, desc = "CodeCompanion Actions" }
    )

    vim.cmd([[cab cc CodeCompanion]])

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
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ", -- Prompt used for interactive LLM calls
          provider = "default", -- default|telescope|mini_pick
          opts = {
            -- show_preset_actions = true, -- Show the preset actions in the action palette?
            show_preset_prompts = false, -- Show the preset prompts in the action palette?
            title = "CodeCompanion Actions",
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
      prompt_library = {
        markdown = {
          dirs = {
            vim.fn.getcwd() .. "/.prompts", -- Can be relative
            vim.fn.stdpath("config") .. "/prompts",
          },
        },
      },
      ignore_warnings = true,
      opts = {
        -- show_defaults = false,
        log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
        language = "Chinese",
      },
      adapters = {
        acp = {
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              defaults = {
                auth_method = "oauth-personal", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
              },
              env = {
                GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
              },
            })
          end,
        },
        http = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              env = {
                url = "http://192.168.2.119:11434",
                -- api_key = "",
              },
              headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer ${api_key}",
              },
              parameters = {
                sync = true,
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "ollama",
        },
        inline = {
          adapter = "ollama",
        },
        cmd = {
          adapter = "ollama",
        },
        background = {
          adapter = "ollama",
        },
      },
    })
  end,
}

return M
