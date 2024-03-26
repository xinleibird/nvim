local M = {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  dependencies = {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        display = {
          render_limit = 16, -- How many LSP messages to show at once
          done_ttl = 1, -- How long a message should persist after completion
          done_icon = require("configs.icons").ui.CheckBold, -- Icon shown when all LSP progress tasks are complete
          progress_icon = { pattern = "circle_halves", period = 1 },
        },
      },
    },
  },
  config = function()
    -- local function open_progress_win()
    --   local bufnr = vim.api.nvim_create_buf(false, true)
    --   vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { " Formatting..." })
    --   local winid = vim.api.nvim_open_win(bufnr, false, {
    --     relative = "editor",
    --     anchor = "SE",
    --     row = vim.o.lines - 2,
    --     col = vim.o.columns,
    --     width = 14,
    --     height = 1,
    --     style = "minimal",
    --     border = "rounded",
    --     focusable = false,
    --     noautocmd = true,
    --   })
    --   vim.bo[bufnr].bufhidden = "wipe"
    --   return winid
    -- end
    --
    -- local winid

    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },

        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },

        vue = { "prettier" },

        html = { "prettier" },

        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },

        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },

        json = { "prettier" },
        jsonc = { "prettier" },

        sh = { "shfmt" },

        yaml = { "prettier" },
        zsh = { "shfmt" },
      },

      format_on_save = function()
        return {
          timeout_ms = 500,
          lsp_fallback = true,
          ---@diagnostic disable-next-line: redundant-return-value
        }, function(err)
          if not err then
            -- winid = open_progress_win()
            require("fidget.notification").notify(
              "Formatting",
              vim.log.levels.INFO,

              ---@diagnostic disable-next-line: missing-fields
              {
                annote = "Finished!",
                ttl = 1,
              }
            )
          end
        end
      end,

      format_after_save = function()
        return {
          lsp_fallback = true,
          ---@diagnostic disable-next-line: redundant-return-value
        }, function()
          -- vim.api.nvim_win_close(winid, true)
        end
      end,
    })
  end,
}

return M
