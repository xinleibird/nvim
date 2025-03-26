local M = {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = "famiu/bufdelete.nvim",
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      group = vim.api.nvim_create_augroup("user_enter_alpha_close_bufferline", { clear = true }),
      command = "set showtabline=0|set laststatus=0",
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaClosed",
      group = vim.api.nvim_create_augroup("user_leave_alpha_open_bufferline", { clear = true }),
      command = "set showtabline=2|set laststatus=3",
    })

    vim.keymap.set("n", "<leader>;", "<cmd>Alpha<CR>", { desc = "Toggle dashboard" })
  end,

  config = function()
    local dashboard = require("alpha.themes.dashboard")

    local function gen_button(sc, txt, keybind, keybind_opts)
      local sc_ = sc:gsub("%s", ""):gsub("Spc", "<leader>")

      local opts = {
        position = "center",
        shortcut = sc,
        cursor = 3,
        width = 50,
        align_shortcut = "right",
        hl_shortcut = "Keyword",
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

    local function buttons()
      return {

        type = "group",
        val = {
          gen_button("sP", "  Recent Projects", "<cmd>Telescope projects<CR>"),
          gen_button("sr", "  Old Files", "<cmd>Telescope oldfiles<CR>"),
          gen_button("sp", "  Find Files", "<cmd>Telescope find_files<CR>"),
          gen_button("st", "󰮗  Live Grep", "<cmd>Telescope live_grep<CR>"),
          gen_button("q ", "󰗽  Quit", "<cmd>qa!<CR>"),
        },
        opts = {
          spacing = 1,
        },
      }
    end

    local function footers()
      local footer_pacman =
        "󰮯··············································󱙝󰊠󱙝"

      local footer_skills =
        "            󰟬  󱏿          󰎙      󰜫  󰨞  "

      dashboard.section.footer.opts.hl = "AlphaFooter"

      local version = " ver " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch

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
          hl = "Number",
        },
      }
    end

    dashboard.opts.layout[1] = { type = "padding", val = 5 }
    dashboard.opts.layout[3] = { type = "padding", val = 2 }
    dashboard.opts.layout[4] = buttons()
    dashboard.opts.layout[5] = footers()

    math.randomseed(os.time())
    local num = math.random(1, 3)

    if num == 1 then
      require("utils.header").generate_small_logo(dashboard)
    elseif num == 2 then
      require("utils.header").generate_big_logo(dashboard)
    else
      require("utils.header").generate_grey_logo(dashboard)
    end

    require("alpha").setup(dashboard.opts)
  end,
}

return M
