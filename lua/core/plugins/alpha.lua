local M = {
  "goolord/alpha-nvim",
  event = "VimEnter",
  init = function()
    local function rest_colors()
      local green = vim.g.terminal_color_2
      local blue = vim.g.terminal_color_4
      local gray = vim.g.terminal_color_8
      local black = vim.g.terminal_color_15
      vim.api.nvim_set_hl(0, "AlphaDashLogoFBlue", { fg = blue })
      vim.api.nvim_set_hl(0, "AlphaDashLogoFGreenBBlue", { fg = green, bg = blue })
      vim.api.nvim_set_hl(0, "AlphaDashLogoFGreen", { fg = green })
      vim.api.nvim_set_hl(0, "AlphaDashLogoFGray", { fg = gray })
      vim.api.nvim_set_hl(0, "AlphaDashLogoFBlackBold", { fg = black, bold = true })
    end

    vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
      group = vim.api.nvim_create_augroup("user_alpha_dashboard_color_init", { clear = true }),
      callback = function()
        rest_colors()
      end,
    })

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

    local function headers()
      return {
        type = "text",
        val = {
          [[                 ]],
          [[                 ]],
          [[                 ]],
          [[                 ]],
          [[                 ]],
          [[                 ]],
          [[     █  █     ]],
          [[     ██ ██     ]],
          [[     █████     ]],
          [[     ██ ███     ]],
          [[     █  █     ]],
          [[                 ]],
          [[                 ]],
          [[N  E  O   V  I  M]],
          [[                 ]],
          [[                 ]],
          [[                 ]],
        },
        opts = {
          position = "center",
          hl = {
            { { "", 0, 0 } },
            { { "", 0, 0 } },
            { { "", 0, 0 } },
            { { "", 0, 0 } },
            { { "", 0, 0 } },
            { { "", 0, 0 } },
            { { "AlphaDashLogoFBlue", 6, 8 }, { "AlphaDashLogoFGreen", 9, 22 } },
            {
              { "AlphaDashLogoFBlue", 6, 8 },
              { "AlphaDashLogoFGreenBBlue", 9, 11 },
              { "AlphaDashLogoFGreen", 12, 24 },
            },
            { { "AlphaDashLogoFBlue", 6, 11 }, { "AlphaDashLogoFGreen", 12, 26 } },
            { { "AlphaDashLogoFBlue", 6, 11 }, { "AlphaDashLogoFGreen", 12, 24 } },
            { { "AlphaDashLogoFBlue", 6, 11 }, { "AlphaDashLogoFGreen", 12, 22 } },
            { { "", 0, 0 } },
            { { "", 0, 0 } },
            { { "AlphaDashLogoFGray", 0, 8 }, { "AlphaDashLogoFBlackBold", 9, 17 } },
          },
          -- wrap = "overflow";
        },
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
          hl = "Number",
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
