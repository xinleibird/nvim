---@module "lazy"
---@type LazySpec
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
        }
      end,

      format_after_save = function()
        return {
          lsp_fallback = true,
        }, function()
          local formatters = require("conform").list_formatters(0)
          local formatter_name = formatters[1].name
          vim.notify(" " .. "**" .. formatter_name .. "**" .. " Formatted！", vim.log.levels.INFO, {
            id = "conform_notify",
            title = "conform.nvim",
            style = "compact",
            timeout = 1000,
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
