local M = {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = function()
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

        json = { "prettier" },
        jsonc = { "prettier" },

        bash = { "shfmt" },
        sh = { "shfmt" },
        zsh = { "shfmt" },

        yaml = { "prettier" },

        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        -- ["_"] = { "trim_whitespace" },
      },

      format_on_save = function()
        if vim.b.disable_autoformat then -- for bigfile disable autoformat
          return
        end
        return {
          timeout_ms = 500,
          lsp_fallback = true,
          ---@diagnostic disable-next-line: redundant-return-value
        }, function(err)
          if not err then
            vim.notify(" Formatting!", vim.log.levels.WARN, {
              id = "conform_notify",
              style = "compact",
              timeout = 0,
              opts = function(notif)
                notif.icon = ""
              end,
            })
          end
        end
      end,

      format_after_save = function()
        return {
          lsp_fallback = true,
        }, function()
          vim.notify(" Format Finished！", vim.log.levels.INFO, {
            id = "conform_notify",
            style = "compact",
            timeout = 500,
            opts = function(notif)
              notif.icon = ""
            end,
          })
        end
      end,
    })
  end,
}

return M
