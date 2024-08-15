local M = {
  "goolord/alpha-nvim",
  event = "VimEnter",
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      group = vim.api.nvim_create_augroup("user_enter_alpha_close_bufferline", { clear = true }),
      command = "set showtabline=0|set laststatus=0",
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaClosed",
      group = vim.api.nvim_create_augroup("user_leave_alpha_close_bufferline", { clear = true }),
      command = "set showtabline=2|set laststatus=3",
    })

    vim.keymap.set("n", "<leader>;", "<cmd>Alpha<CR>", { desc = "Toggle Alpha" })
  end,

  opts = function()
    local function gen_button(sc, txt, keybind, keybind_opts)
      local sc_ = sc:gsub("%s", ""):gsub("Spc", "<leader>")

      local opts = {
        position = "center",
        shortcut = sc,
        cursor = 3,
        width = 50,
        align_shortcut = "right",
        hl_shortcut = "AlphaShortcut",
      }
      if keybind then
        keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, keybind, keybind_opts }
      end

      local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
      end

      return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
      }
    end

    local function headers()
      return {
        type = "text",
        val = require("utils.banner").generate(),
        opts = { position = "center", hl = "AlphaHeader" },
      }
    end

    local function buttons()
      return {

        type = "group",
        val = {
          gen_button("Spc  bn", "  New Buffer"),
          gen_button("Spc  sp", "  Find Files"),
          gen_button("Spc  sr", "  Old Files"),
          gen_button("Spc  st", "󰮗  Live Grep"),
          gen_button("Spc  sP", "  Recent Projects"),
          gen_button("Spc  q ", "󰗽  Quit"),
        },
        opts = {
          spacing = 1,
          hl = "AlphaButtons",
        },
      }
    end

    local function footers()
      local footer_pacman =
        "󰮯··············································󱙝󰊠󱙝"

      local footer_skills =
        "            󰟬  󱏿          󰎙      󰜫  󰨞  "

      local version = " ver "
        .. vim.version().major
        .. "."
        .. vim.version().minor
        .. "."
        .. vim.version().patch

      local lazy_stats = require("lazy").stats()
      local plugins = lazy_stats.count .. " plugins "

      local padding_width = vim.fn.strdisplaywidth(footer_pacman)
        - vim.fn.strdisplaywidth(version)
        - vim.fn.strdisplaywidth(plugins)

      local padding = string.rep(" ", padding_width)

      local footer_summary = version .. padding .. plugins

      return {

        type = "text",
        val = { footer_pacman, footer_skills, footer_summary },
        opts = {
          position = "center",
          hl = "AlphaFooter",
        },
      }
    end

    return {
      layout = {
        { type = "padding", val = 2 },
        headers(),
        { type = "padding", val = 2 },
        buttons(),
        footers(),
      },
    }
  end,

  config = function(_, opts)
    require("alpha").setup(opts)
  end,
}

return M
