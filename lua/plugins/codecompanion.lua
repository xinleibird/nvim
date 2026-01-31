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
    vim.keymap.set("v", "<Leader>aa", function()
      local context = require("codecompanion.utils.context").get(vim.api.nvim_get_current_buf(), {})
      local content = table.concat(context.lines, "\n")
      local codecompanion = require("codecompanion")
      local chat = codecompanion.last_chat()

      if chat then
        local bufnr = chat.last_chat().ui.chat_bufnr
        if vim.api.nvim_buf_is_valid(bufnr) then
          local id = vim.fn.bufwinid(bufnr)
          vim.fn.win_gotoid(id)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true), "n", false)
        end
      end

      if not chat then
        chat = codecompanion.chat({ context = {} })

        if not chat then
          local log = require("codecompanion.utils.log")
          return log:warn("Could not create chat buffer")
        end
      end

      local config = require("codecompanion.config")
      chat:add_buf_message({
        role = config.constants.USER_ROLE,
        content = "下面是来自文件 `"
          .. vim.fn.fnamemodify(context.filename, ":.")
          .. "` 的代码片段：\n\n```"
          .. context.filetype
          .. "\n"
          .. content
          .. "\n```\n\n",
      })
      chat.ui:open()
    end, { noremap = true, silent = true, desc = "CodeCompanionChat Add" })
    vim.keymap.set(
      "v",
      "<Leader>ae",
      "<cmd>CodeCompanion /explain<cr>",
      { noremap = true, silent = true, desc = "CodeCompanion /explain" }
    )
    vim.keymap.set(
      { "n", "v" },
      "<Leader>ap",
      "<cmd>CodeCompanionActions<cr>",
      { noremap = true, silent = true, desc = "CodeCompanion Actions" }
    )
    vim.keymap.set(
      { "n", "v" },
      "<Leader>ac",
      "<cmd>CodeCompanion /commit<cr>",
      { noremap = true, silent = true, desc = "CodeCompanion /commit" }
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
          intro_message = "",
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
          opts = {
            show_presets = false,
          },
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              defaults = {
                auth_method = "oauth-personal", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
              },
              env = {
                GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
              },
              schema = {
                model = {
                  default = "gemini-3-flash-preview",
                },
              },
            })
          end,
          qwen_code = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              name = "qwen_code",
              formatted_name = "Qwen Code",
              commands = {
                default = {
                  "qwen",
                  "--experimental-acp",
                },
                yolo = {
                  "qwen",
                  "--yolo",
                  "--experimental-acp",
                },
              },
              defaults = {
                auth_method = "qwen-oauth",
                oauth_credentials_path = vim.fs.abspath("~/.qwen/oauth_creds.json"),
              },
              handlers = {
                -- do not auth again if oauth_credentials is already exists
                auth = function(self)
                  local oauth_credentials_path = self.defaults.oauth_credentials_path
                  return (oauth_credentials_path and vim.fn.filereadable(oauth_credentials_path)) == 1
                end,
              },
            })
          end,
        },
        http = {
          opts = {
            show_presets = false,
          },
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
          adapter = require("configs.settings").codecompanion_adapter,
          keymaps = {
            send = {
              modes = {
                n = "<C-s>",
                i = "<C-s>",
              },
              callback = function(chat)
                vim.cmd("stopinsert")
                vim.api.nvim_command("normal! G")
                chat:submit()
              end,
              description = "[Request] Send response",
            },
            clear = {
              modes = { n = "<C-x>" },
              callback = "keymaps.clear",
              description = "[Chat] Clear",
            },
          },
        },
      },
    })
  end,
}

return M
