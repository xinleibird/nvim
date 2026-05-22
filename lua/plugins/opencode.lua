---@module "lazy"
---@type LazySpec
local M = {
  "nickjvandyke/opencode.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  version = "*", -- Latest stable release
  dependencies = {
    {
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {
          keys = {
            i_cr = {
              "<cr>",
              {
                "cmp_accept",
                "confirm",
                function()
                  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
                  vim.api.nvim_feedkeys(esc, "n", false)
                end,
              },
              mode = { "i", "n" },
              expr = true,
            },
          },
        }, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(...)
              return require("opencode").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        url = nil,
        username = vim.env.OPENCODE_SERVER_USERNAME or "opencode", -- Same env vars and defaults as `opencode`
        password = vim.env.OPENCODE_SERVER_PASSWORD,
        start = function() end,
        stop = function() end,
        toggle = function() end,
      },
      contexts = {
        ["@this"] = function(context)
          return context:this()
        end,
        ["@buffer"] = function(context)
          return context:buffer()
        end,
        ["@buffers"] = function(context)
          return context:buffers()
        end,
        ["@visible"] = function(context)
          return context:visible_text()
        end,
        ["@diagnostics"] = function(context)
          return context:diagnostics()
        end,
        ["@quickfix"] = function(context)
          return context:quickfix()
        end,
        ["@diff"] = function(context)
          return context:git_diff()
        end,
        ["@marks"] = function(context)
          return context:marks()
        end,
        ["@grapple"] = function(context)
          return context:grapple_tags()
        end,
      },
      ask = {
        prompt = "Ask opencode: ",
        completion = "customlist,v:lua.opencode_completion",
        snacks = {
          icon = "󰚩 ",
          win = {
            title_pos = "left",
            relative = "cursor",
            row = -3, -- Row above the cursor
            col = 0, -- Align with the cursor
            keys = {
              i_cr = {
                desc = "submit",
              },
            },
            b = {
              completion = true,
            },
            bo = {
              filetype = "opencode_ask",
            },
            on_buf = function(win)
              -- Make sure your completion plugin has the LSP source enabled,
              -- either by default or for the `opencode_ask` filetype!
              vim.lsp.start(require("opencode.ui.ask.cmp"), {
                bufnr = win.buf,
              })
            end,
          },
        },
      },
      select = {
        prompt = "opencode: ",
        prompts = false,
        commands = {
          ["session.new"] = "Start a new session",
          ["session.select"] = "Select a session",
          ["session.share"] = "Share the current session",
          ["session.interrupt"] = "Interrupt the current session",
          ["session.compact"] = "Compact the current session (reduce context size)",
          ["session.undo"] = "Undo the last action in the current session",
          ["session.redo"] = "Redo the last undone action in the current session",
          ["agent.cycle"] = "Cycle the selected agent",
          ["prompt.submit"] = "Submit the current prompt",
          ["prompt.clear"] = "Clear the current prompt",
        },
        server = true,
        snacks = {
          preview = "preview",
          layout = {
            preset = "vscode",
            hidden = {}, -- preview is hidden by default in `vim.ui.select`
          },
        },
      },
      lsp = {
        enabled = false,
        filetypes = nil,
        handlers = {
          hover = {
            enabled = true,
            model = nil,
          },
          code_action = { enabled = true },
        },
      },
      events = {
        enabled = true,
        reload = true,
        permissions = {
          enabled = true,
          idle_delay_ms = 1000,
          edits = {
            enabled = true,
          },
        },
      },
    }

    vim.o.autoread = true -- Required for `opts.events.reload`

    vim.keymap.set({ "n", "x" }, "<leader>aa", function()
      require("opencode").ask("", { submit = true })
    end, { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<leader>ap", function()
      require("opencode").select()
    end, { desc = "Select opencode…" })

    vim.keymap.set({ "n", "i", "x" }, "<C-Esc>", function()
      require("opencode").command("session.interrupt")
    end, { desc = "Interrupt the current session" })
    vim.keymap.set({ "n", "i", "x" }, "<C-t>", function()
      require("opencode").command("agent.cycle")
    end, { desc = "Cycle the selected agent" })

    vim.keymap.set("n", "<S-C-u>", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "Scroll opencode up" })
    vim.keymap.set("n", "<S-C-d>", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "Scroll opencode down" })
  end,
}

return M
