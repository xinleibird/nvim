---@module "lazy"
---@type LazySpec
local M = {
  "olimorris/codecompanion.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    opts = {
      -- show_defaults = false,
      log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
      language = "Chinese",
    },
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
          layout = "float",
          border = "rounded",
          width = 0.8,
          height = 0.8,
          opts = {
            numberwidth = 6,
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
    adapters = {
      acp = {
        opts = {
          show_presets = false,
        },
        opencode = "opencode",
        gemini_cli = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            commands = {
              default = {
                "gemini",
                "--acp",
              },
              yolo = {
                "gemini",
                "--yolo",
                "--acp",
              },
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
        agent = "opencode",
        agents = {
          gemini_cli = {
            cmd = "gemini",
            description = "Gemini CLI",
            provider = "terminal",
          },
          opencode = {
            cmd = "opencode",
            description = "OpenCode",
            provider = "terminal",
          },
        },
      },
      chat = {
        adapter = "opencode",
        keymaps = {
          send = {
            modes = {
              n = "<C-s>",
              i = "<C-s>",
            },
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
              n = "<c-s-q>",
              i = "<c-s-q>",
            },
            callback = function(chat)
              chat:close()
            end,
            description = "[Chat] Close",
          },
        },
      },
    },
  },
  init = function()
    local request_status = {}
    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeCompanion*",
      group = vim.api.nvim_create_augroup("user_codecompanion_progress_notify", { clear = true }),
      callback = function(request)
        local status = request.match
        local bufnr = request.buf

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        local adapter = request.data and request.data.adapter or {}
        local adapter_name = adapter.formatted_name or adapter.name or "CodeCompanion"

        if status == "CodeCompanionRequestStarted" then
          vim.notify(" AI Thinking..." .. ("**%s**"):format(adapter_name), vim.log.levels.WARN, {
            id = "codecompanion_notif",
            style = "compact",
            title = "CodeCompanion",
            timeout = 0,
            opts = function(notif)
              notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
          request_status[bufnr] = "started"
        end
        if status == "CodeCompanionChatStopped" and request_status[bufnr] == "started" then
          vim.notify(" AI Abort!", vim.log.levels.ERROR, {
            id = "codecompanion_notif",
            style = "compact",
            icon = "󱈸",
            title = "CodeCompanion",
            timeout = 1500,
          })
          request_status[bufnr] = "stopped"
        end
        if status == "CodeCompanionRequestFinished" and request_status[bufnr] ~= "stopped" then
          vim.notify(" AI Done！", vim.log.levels.INFO, {
            id = "codecompanion_notif",
            style = "compact",
            icon = "",
            title = "CodeCompanion",
            timeout = 1500,
          })
          request_status[bufnr] = "finished"
        end

        if status == "CodeCompanionToolApprovalRequested" then
          vim.notify(" Your Choice?", vim.log.levels.ERROR, {
            id = "codecompanion_choice",
            style = "compact",
            icon = "",
            title = "CodeCompanion",
            timeout = 0,
          })
        end
        if status == "CodeCompanionToolApprovalFinished" then
          vim.notify(" OK!", vim.log.levels.INFO, {
            id = "codecompanion_choice",
            style = "compact",
            title = "CodeCompanion",
            icon = "",
            timeout = 1500,
          })
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
      if chat then
        chat:toggle()
      end
    end, { noremap = true, silent = true, desc = "CodeCompanionChat Toggle" })
    vim.keymap.set({ "n", "v", "t" }, "<C-S-.>", function()
      local cli = require("codecompanion.interactions.cli").last_cli()
      if cli then
        cli.toggle()
      end
    end, { noremap = true, silent = true, desc = "CodeCompanionCLI Toggle" })
  end,
}

return M
