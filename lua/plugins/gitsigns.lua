local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufRead",
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "┊" },
        untracked = { text = "│" },
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]g", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]g", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Next hunk" })
        map("n", "<leader>gj", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]g", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Next hunk" })

        map("n", "[g", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[g", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Prev hunk" })
        map("n", "<leader>gk", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[g", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Prev hunk" })

        -- Actions
        map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })

        map("v", "<leader>gs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage hunk" })

        map("v", "<leader>gr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset hunk" })

        map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage Buff" })
        map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset Buff" })
        map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>gP", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

        map("n", "<leader>gb", function()
          gitsigns.blame_line({ full = true })
        end, { desc = "Blame line" })

        map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff this" })

        map("n", "<leader>gD", function()
          gitsigns.diffthis("~")
        end, { desc = "Diff this HEAD" })

        map("n", "<leader>gQ", function()
          gitsigns.setqflist("all")
        end, { desc = "ALL to qflist" })
        map("n", "<leader>gq", gitsigns.setqflist, { desc = "To qflist" })

        -- Toggles
        map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
        ---@diagnostic disable-next-line: deprecated
        map("n", "<leader>gtd", gitsigns.toggle_deleted, { desc = "Toggle deleted" })
        map("n", "<leader>gtw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

        -- Text object
        -- map({'o', 'x'}, 'gih', gitsigns.select_hunk)
      end,
    })
  end,
}

return M
