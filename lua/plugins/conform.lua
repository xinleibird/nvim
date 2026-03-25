---@module "lazy"
---@type LazySpec
local M = {
  "stevearc/conform.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  config = function()
    require("conform").setup({
      formatters = {
        auto_indent = {
          format = function(_, ctx, lines, callback)
            local new_lines = {}

            -- Trim trailing whitespace from each line
            for _, line in ipairs(lines) do
              table.insert(new_lines, (line:gsub("%s+$", "")))
            end

            -- Remove trailing empty lines
            while #new_lines > 0 and new_lines[#new_lines] == "" do
              table.remove(new_lines)
            end

            -- gg=G
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(ctx.buf) then
                local view = vim.fn.winsaveview()
                vim.api.nvim_buf_call(ctx.buf, function()
                  vim.cmd("silent! normal! gg=G")
                end)
                vim.fn.winrestview(view)
              end
              callback(nil, new_lines)
            end)
          end,
        },
      },
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

        toml = { "taplo" },

        yaml = { "prettier" },

        ["_"] = { "auto_indent" },

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
          if #formatters == 0 then
            return
          end
          local formatter_names = ""
          for _, formatter in ipairs(formatters) do
            formatter_names = #formatter_names == 0 and formatter.name or formatter_names .. " " .. formatter.name
          end

          vim.notify("󰃢 Formatted by: " .. "**" .. formatter_names .. "**", vim.log.levels.INFO, {
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
