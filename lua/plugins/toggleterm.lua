local M = {
  "akinsho/toggleterm.nvim",
  event = "VimEnter",
  version = "*",
  init = function()
    local function get_map()
      if vim.g.neovide then
        return "<D-j>"
      else
        return "<M-j>"
      end
    end

    vim.keymap.set({ "n", "t" }, get_map(), "<cmd>ToggleTerm<CR>", { desc = "Horizontal term" })
    vim.keymap.set({ "n", "t" }, "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Horizontal term" })

    vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "Escape terminal mode" })
  end,
  config = function()
    require("toggleterm").setup({
      highlights = {
        Normal = {
          link = "ToggleTermBg",
        },
        NormalFloat = {
          link = "ToggleTermBg",
        },
        SignColumn = {
          link = "ToggleTermBg",
        },
      },
      winbar = {
        enabled = false,
        name_formatter = function(term) --  term: Terminal
          return term.name
        end,
      },
      on_open = function(term)
        vim.defer_fn(function()
          vim.wo[term.window].winbar = ""
        end, 0)

        local name = vim.fn.bufname("neo-tree")
        local winnr = vim.fn.bufwinnr(name)

        if winnr ~= -1 then
          vim.defer_fn(function()
            vim.cmd("Neotree toggle")
            vim.cmd("Neotree toggle")
            vim.cmd("wincmd p")
          end, 100)
        end
      end,
    })
  end,
}

return M
