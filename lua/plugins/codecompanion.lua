local M = {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "echasnovski/mini.diff",
    "saghen/blink.cmp",
  },
  init = function()
    local function smart_codecompanion_window()
      require("codecompanion.config").config.display.chat.window.layout = vim.o.columns > 120 and "vertical"
        or "horizontal"
      require("codecompanion.config").config.display.chat.window.position = vim.o.columns > 120 and "right" or "top"
      require("codecompanion.config").config.display.chat.window.height = 0.36
      require("codecompanion.config").config.display.chat.window.width = 0.46
    end
    vim.api.nvim_create_autocmd("VimResized", {
      group = vim.api.nvim_create_augroup("user_smart_codecompanion_window", { clear = true }),
      callback = function()
        smart_codecompanion_window()
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "codecompanion",
      group = vim.api.nvim_create_augroup("user_toggle_wincmd_keymap_for_codecompanion_float_window", { clear = true }),
      callback = function()
        local win_config = vim.api.nvim_win_get_config(0)
        if win_config.relative ~= "" then
          vim.keymap.set({ "n", "t", "i" }, "<C-h>", "", { silent = true, buffer = true })
          vim.keymap.set({ "n", "t", "i" }, "<C-l>", "", { silent = true, buffer = true })
          vim.keymap.set({ "n", "t", "i" }, "<C-j>", "", { silent = true, buffer = true })
          vim.keymap.set({ "n", "t", "i" }, "<C-k>", "", { silent = true, buffer = true })
        end
      end,
    })

    vim.keymap.set(
      { "n" },
      "<Leader>aa",
      "<cmd>CodeCompanionChat Toggle<cr>",
      { noremap = true, silent = true, desc = "CodeCompanion Toggle Chat" }
    )
    vim.keymap.set(
      { "v" },
      "<Leader>aa",
      "<cmd>CodeCompanion /add<cr>",
      { noremap = true, silent = true, desc = "CodeCompanion /add" }
    )
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

    local request_status
    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeCompanionRequest*",
      callback = function(request)
        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        local status = request.match

        if status == "CodeCompanionRequestStarted" then
          local adapter = request.data.adapter
          local adapter_name = (adapter and (adapter.formatted_name or adapter.name))
            or require("configs.settings").codecompanion_adapter
            or "CodeCompanion"
          vim.notify(" AI Thinking..." .. ("**%s**"):format(adapter_name), vim.log.levels.WARN, {
            id = "codecompanion_notif",
            style = "compact",
            timeout = 0,
            opts = function(notif)
              notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
          request_status = "started"
        elseif status == "CodeCompanionRequestStopped" and request_status == "started" then
          vim.notify(" AI Abort!", vim.log.levels.ERROR, {
            id = "codecompanion_notif",
            style = "compact",
            icon = "",
            timeout = 1500,
            opts = function(notif)
              notif.icon = ""
            end,
          })
          request_status = "stopped"
        elseif status == "CodeCompanionRequestFinished" and request_status ~= "stopped" then
          vim.notify(" AI Done！", vim.log.levels.INFO, {
            id = "codecompanion_notif",
            style = "compact",
            icon = "",
            timeout = 1500,
            opts = function(notif)
              notif.icon = ""
            end,
          })
          request_status = "finished"
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
            layout = vim.o.columns > 120 and "vertical" or "horizontal",
            position = vim.o.columns > 120 and "right" or "top",
            height = 0.36,
            width = 0.46,
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
          -- create your own configuration file lua/configs/settings
          -- the KEY is codecompanion_adapter
          ---@type "gemini_cli"|"qwen_code"|"ollama"|nil
          adapter = (function()
            local ok, settings = pcall(require, "configs.settings")
            return ok and settings.codecompanion_adapter or nil
          end)(),
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
            stop = {
              modes = {
                n = "q",
              },
              callback = function(chat)
                vim.api.nvim_exec_autocmds("User", {
                  pattern = "CodeCompanionRequestStopped",
                  data = {},
                })
                chat:stop()
              end,
              description = "[Request] Stop",
            },
            clear = {
              modes = { n = "<C-x>" },
              callback = "keymaps.clear",
              description = "[Chat] Clear",
            },
          },
          variables = {
            ["url"] = nil,
          },
        },
      },
    })
  end,
}

return M
