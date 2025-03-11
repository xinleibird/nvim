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

  config = function()
    local dashboard = require("alpha.themes.dashboard")

    -- helper function for utf8 chars
    local function getCharLen(s, pos)
      local byte = string.byte(s, pos)
      if not byte then
        return nil
      end
      return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
    end

    local function applyColors(logo, colors, logoColors)
      dashboard.section.header.val = logo

      for key, color in pairs(colors) do
        local name = "Alpha" .. key
        vim.api.nvim_set_hl(0, name, color)
        colors[key] = name
      end

      dashboard.section.header.opts.hl = {}
      for i, line in ipairs(logoColors) do
        local highlights = {}
        local pos = 0

        for j = 1, #line do
          local opos = pos
          pos = pos + getCharLen(logo[i], opos + 1)

          local color_name = colors[line:sub(j, j)]
          if color_name then
            table.insert(highlights, { color_name, opos, pos })
          end
        end

        table.insert(dashboard.section.header.opts.hl, highlights)
      end

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

      dashboard.opts.layout[1] = { type = "padding", val = 4 }
      dashboard.opts.layout[3] = { type = "padding", val = 4 }
      dashboard.opts.layout[4] = buttons()
      dashboard.opts.layout[5] = footers()

      return dashboard.opts
    end

    require("alpha").setup(applyColors({
      [[  ███       ███  ]],
      [[  ████      ████ ]],
      [[  ████     █████ ]],
      [[ █ ████    █████ ]],
      [[ ██ ████   █████ ]],
      [[ ███ ████  █████ ]],
      [[ ████ ████ ████ ]],
      [[ █████  ████████ ]],
      [[ █████   ███████ ]],
      [[ █████    ██████ ]],
      [[ █████     █████ ]],
      [[ ████      ████ ]],
      [[  ███       ███  ]],
      [[                    ]],
      [[  N  E  O  V  I  M  ]],
    }, {
      ["b"] = { fg = "#3399ff", ctermfg = 33, bold = true },
      ["a"] = { fg = "#53C670", ctermfg = 35 },
      ["g"] = { fg = "#39ac56", ctermfg = 29 },
      ["h"] = { fg = "#33994d", ctermfg = 23 },
      ["i"] = { fg = "#33994d", bg = "#39ac56", ctermfg = 23, ctermbg = 29 },
      ["j"] = { fg = "#53C670", bg = "#33994d", ctermfg = 35, ctermbg = 23 },
      ["k"] = { fg = "#30A572", ctermfg = 36 },
    }, {
      [[  kkkka       gggg  ]],
      [[  kkkkaa      ggggg ]],
      [[ b kkkaaa     ggggg ]],
      [[ bb kkaaaa    ggggg ]],
      [[ bbb kaaaaa   ggggg ]],
      [[ bbbb aaaaaa  ggggg ]],
      [[ bbbbb aaaaaa igggg ]],
      [[ bbbbb  aaaaaahiggg ]],
      [[ bbbbb   aaaaajhigg ]],
      [[ bbbbb    aaaaajhig ]],
      [[ bbbbb     aaaaajhi ]],
      [[ bbbbb      aaaaajh ]],
      [[  bbbb       aaaaa  ]],
      [[                    ]],
      [[  a  a  a  b  b  b  ]],
    }))
  end,
}

return M
