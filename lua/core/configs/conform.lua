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

local M = {
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

    yaml = { "prettier" },

    sh = { "shfmt" },
    zsh = { "shfmt" },
  },

  format_on_save = function()
    return {
      timeout_ms = 500,
      lsp_fallback = true,
    }, function(err)
      if not err then
        -- winid = open_progress_win()
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
    }, function()
      -- vim.api.nvim_win_close(winid, true)
    end
  end,
}

return M
