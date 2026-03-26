---@module "lazy"
---@type LazySpec
local M = {
  "olimorris/codecompanion.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim",
  },
  opts = {
    display = {
      action_palette = {
        width = 95,
        height = 10,
        prompt = "Prompt ", -- Prompt used for interactive LLM calls
        provider = "default", -- default|telescope|mini_pick|snacks
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
          -- layout = vim.o.columns > 120 and "vertical" or "horizontal",
          -- position = vim.o.columns > 120 and "right" or "top",
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
        gemini_cli = "gemini_cli",
        qwen_code = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            name = "qwen_code",
            formatted_name = "Qwen Code",
            commands = {
              default = {
                "qwen",
                "--acp",
                "--web-search-default=google",
              },
              yolo = {
                "qwen",
                "--yolo",
                "--acp",
                "--web-search-default=google",
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
      },
    },
    interactions = {
      cli = {
        agent = "qwen_code",
        agents = {
          qwen_code = {
            cmd = "qwen",
            args = {
              "--web-search-default=google",
            },
            description = "Qwen Code",
            provider = "terminal",
          },
        },
      },
      chat = {
        adapter = "qwen_code",
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
              n = "<C-c>",
              i = "<C-c>",
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
            modes = {
              n = "<C-x>",
              i = "<C-x>",
            },
            callback = "keymaps.clear",
            description = "[Chat] Clear",
          },
          close = {
            modes = {
              n = "<c-q>",
              i = "<c-q>",
            },
            callback = function(chat)
              chat:close()
            end,
            description = "[Chat] Close",
          },
        },
      },
    },
    extensions = {
      history = {
        enabled = true,
        opts = {
          -- Keymap to open history from chat buffer (default: gh)
          keymap = "gh",
          -- Keymap to save the current chat manually (when auto_save is disabled)
          save_chat_keymap = "sc",
          -- Save all chats by default (disable to save only manually using 'sc')
          auto_save = true,
          -- Number of days after which chats are automatically deleted (0 to disable)
          expiration_days = 0,
          -- Picker interface (auto resolved to a valid picker)
          picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
          ---Optional filter function to control which chats are shown when browsing
          chat_filter = nil, -- function(chat_data) return boolean end
          -- Customize picker keymaps (optional)
          picker_keymaps = {
            rename = { n = "<F2>", i = "<F2>" },
            delete = { n = "d", i = "<C-d>" },
            duplicate = { n = "<C-y>", i = "<C-y>" },
          },
          ---Automatically generate titles for new chats
          auto_generate_title = false,
          title_generation_opts = {
            ---Adapter for generating titles (defaults to current chat adapter)
            adapter = nil, -- "copilot"
            ---Model for generating titles (defaults to current chat model)
            model = nil, -- "gpt-4o"
            ---Number of user prompts after which to refresh the title (0 to disable)
            refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
            ---Maximum number of times to refresh the title (default: 3)
            max_refreshes = 3,
            format_title = function(original_title)
              -- this can be a custom function that applies some custom
              -- formatting to the title.
              return original_title
            end,
          },
          ---On exiting and entering neovim, loads the last chat on opening chat
          continue_last_chat = false,
          ---When chat is cleared with `gx` delete the chat from history
          delete_on_clearing_chat = true,
          ---Directory path to save the chats
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
          ---Enable detailed logging for history extension
          enable_logging = false,

          -- Summary system
          summary = {
            -- Keymap to generate summary for current chat (default: "gcs")
            create_summary_keymap = "gcs",
            -- Keymap to browse summaries (default: "gbs")
            browse_summaries_keymap = "gbs",

            generation_opts = {
              adapter = nil, -- defaults to current chat adapter
              model = nil, -- defaults to current chat model
              context_size = 90000, -- max tokens that the model supports
              include_references = true, -- include slash command content
              include_tool_outputs = true, -- include tool execution results
              system_prompt = nil, -- custom system prompt (string or function)
              format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
            },
          },

          -- Memory system (requires VectorCode CLI)
          memory = {
            -- Automatically index summaries when they are generated
            auto_create_memories_on_summary_generation = true,
            -- Path to the VectorCode executable
            vectorcode_exe = "vectorcode",
            -- Tool configuration
            tool_opts = {
              -- Default number of memories to retrieve
              default_num = 10,
            },
            -- Enable notifications for indexing progress
            notify = true,
            -- Index all existing memories on startup
            -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
            index_on_startup = false,
          },
        },
      },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeCompanionChatCreated",
      group = vim.api.nvim_create_augroup("user_registering_codecompanion_callback", { clear = true }),
      callback = function(args)
        local chat = require("codecompanion").buf_get_chat(args.data.bufnr)
        if chat.adapter.type == "acp" and chat.adapter.formatted_name == "Qwen Code" then
          chat:add_callback("on_closed", function()
            local nvim_pid = vim.fn.getpid()
            local sub_pids = vim.fn.systemlist('pgrep -f "^/.*qwen.*--acp"')
            for _, sub_pid in pairs(sub_pids) do
              local ancestors = require("utils").get_ancestors(sub_pid)
              local is_descendant = vim.tbl_contains(ancestors, nvim_pid)
              if is_descendant then
                vim.fn.system(("kill -9 " .. sub_pid))
              end
            end
          end)
        end
      end,
    })

    vim.api.nvim_create_autocmd("QuitPre", {
      group = vim.api.nvim_create_augroup("user_quit_nvim_make_sure_qwen_subprocess_terminated", { clear = true }),
      callback = function()
        local chat = require("codecompanion.interactions.chat").last_chat()
        if chat then
          chat:close()
        end

        local cli_session = require("codecompanion.interactions.cli").last_cli()
        if cli_session then
          cli_session:close()
        end
      end,
    })

    -- auto enter insert mode in snacks_picker_input buffer, for history picker issue
    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
      group = vim.api.nvim_create_augroup("user_snacks_picker_input", { clear = true }),
      pattern = "snacks_picker_input",
      callback = function()
        vim.schedule(function()
          local picker = Snacks.picker.get()[1]
          if picker and picker.opts.title == "Saved Chats" then
            if vim.fn.mode() ~= "i" then
              vim.cmd.startinsert()
            end
          end
        end)
      end,
    })

    local request_status = {}
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    local spinner_index = 1
    vim.uv.new_timer():start(
      80,
      80,
      vim.schedule_wrap(function()
        spinner_index = (spinner_index % #spinner) + 1
      end)
    )
    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeCompanionRequest*",
      callback = function(request)
        local status = request.match
        local bufnr = request.buf

        if status == "CodeCompanionRequestStarted" then
          local adapter = request.data and request.data.adapter or {}
          local adapter_name = adapter.formatted_name or adapter.name or "CodeCompanion"
          vim.notify(" AI Thinking..." .. ("**%s**"):format(adapter_name), vim.log.levels.WARN, {
            id = "codecompanion_notif",
            style = "compact",
            title = "CodeCompanion",
            timeout = 0,
            opts = function(notif)
              notif.icon = spinner[spinner_index]
            end,
          })
          request_status[bufnr] = "started"
        elseif status == "CodeCompanionRequestStopped" and request_status[bufnr] == "started" then
          vim.notify(" AI Abort!", vim.log.levels.ERROR, {
            id = "codecompanion_notif",
            style = "compact",
            icon = "",
            title = "CodeCompanion",
            timeout = 1500,
            opts = function(notif)
              notif.icon = ""
            end,
          })
          request_status[bufnr] = "stopped"
        elseif status == "CodeCompanionRequestFinished" and request_status[bufnr] ~= "stopped" then
          vim.notify(" AI Done！", vim.log.levels.INFO, {
            id = "codecompanion_notif",
            style = "compact",
            icon = "",
            title = "CodeCompanion",
            timeout = 1500,
            opts = function(notif)
              notif.icon = ""
            end,
          })
          request_status[bufnr] = "finished"
        end
      end,
    })
  end,
  config = function(_, opts)
    require("codecompanion").setup(opts)

    vim.keymap.set({ "n" }, "<Leader>aa", function()
      vim.cmd("CodeCompanionChat Toggle")
    end, { noremap = true, silent = true, desc = "CodeCompanion Toggle Chat" })

    vim.keymap.set({ "v" }, "<Leader>aa", function()
      vim.cmd("CodeCompanion /add")
    end, { noremap = true, silent = true, desc = "CodeCompanion /add" })

    vim.keymap.set({ "n", "v" }, "<Leader>ae", function()
      vim.cmd("CodeCompanion /explain")
    end, { noremap = true, silent = true, desc = "CodeCompanion /explain" })

    vim.keymap.set({ "n", "v" }, "<Leader>af", function()
      vim.cmd("CodeCompanion /fix")
    end, { noremap = true, silent = true, desc = "CodeCompanion /fix" })

    vim.keymap.set({ "n", "v" }, "<Leader>al", function()
      vim.cmd("CodeCompanion /lsp")
    end, { noremap = true, silent = true, desc = "CodeCompanion /lsp" })

    vim.keymap.set({ "n", "v" }, "<Leader>aw", function()
      vim.cmd("CodeCompanion /workflow")
    end, { noremap = true, silent = true, desc = "CodeCompanion /workflow" })

    vim.keymap.set({ "n", "v" }, "<Leader>aP", function()
      vim.cmd("CodeCompanionActions")
    end, { noremap = true, silent = true, desc = "CodeCompanion Actions" })

    vim.keymap.set({ "n", "v" }, "<Leader>ap", function()
      vim.cmd("CodeCompanionHistory")
    end, { noremap = true, silent = true, desc = "CodeCompanion History" })

    vim.keymap.set({ "n", "v" }, "<Leader>ac", function()
      local cli_session = require("codecompanion.interactions.cli").last_cli()
      if cli_session then
        require("codecompanion.interactions.cli").toggle()
      else
        vim.cmd("CodeCompanionCLI")
      end
    end, { noremap = true, silent = true, desc = "CodeCompanion Toggle CLI" })

    vim.keymap.set({ "n", "v", "t" }, "<C-.>", function()
      local codecompanion = require("codecompanion")
      local chat = codecompanion.last_chat()
      local cli_session = require("codecompanion.interactions.cli").last_cli()

      if chat == nil and cli_session == nil then
        return
      end

      if (chat and chat:is_visible()) and (cli_session and not cli_session.is_visible()) then
        require("codecompanion.interactions.cli").toggle()
        return
      end

      if (chat and not chat:is_visible()) and (cli_session and cli_session.is_visible()) then
        chat:toggle()
        return
      end

      if chat then
        chat:toggle()
      end
      if cli_session then
        require("codecompanion.interactions.cli").toggle()
      end
    end, { noremap = true, silent = true, desc = "CodeCompanion Toggle" })
  end,
}

return M
