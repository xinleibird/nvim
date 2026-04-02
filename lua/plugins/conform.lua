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
        beautysh = {
          append_args = { "-i", "2" },
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },

        bash = { "beautysh" },
        css = { "oxfmt" },
        graphql = { "oxfmt" },
        html = { "oxfmt" },
        javascript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        json = { "oxfmt" },
        json5 = { "oxfmt" },
        jsonc = { "oxfmt" },
        less = { "oxfmt" },
        markdown = { "oxfmt" },
        scss = { "oxfmt" },
        sh = { "beautysh" },
        toml = { "oxfmt" },
        typescript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        vue = { "oxfmt" },
        yaml = { "oxfmt" },
        zsh = { "beautysh" },

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
          ---@diagnostic disable-next-line: redundant-return-value
        }, function(err)
          if not err then
            require("fidget.notification").notify("Formatting", vim.log.levels.INFO, {
              annote = "Finished!",
              ttl = 1,
            })
          end
        end
      end,

      format_after_save = function()
        return {
          lsp_fallback = true,
        }, function() end
      end,
    })
  end,
}

return M
