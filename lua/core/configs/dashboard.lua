local if_nil = vim.F.if_nil

local default_terminal = {
  type = "terminal",
  command = nil,
  width = 69,
  height = 8,
  opts = {
    redraw = true,
    window_config = {},
  },
}

local function init()
  local function rest_colors()
    local green = vim.g.terminal_color_2
    local blue = vim.g.terminal_color_4
    local gray = vim.g.terminal_color_8
    local black = vim.g.terminal_color_15
    vim.api.nvim_set_hl(0, "NeovimDashboardLogo1", { fg = blue })
    vim.api.nvim_set_hl(0, "NeovimDashboardLogo2", { fg = green, bg = blue })
    vim.api.nvim_set_hl(0, "NeovimDashboardLogo3", { fg = green })
    vim.api.nvim_set_hl(0, "NeovimDashboardLogo4", { fg = gray })
    vim.api.nvim_set_hl(0, "NeovimDashboardLogo5", { fg = black, bold = true })
  end

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("neovim_alpha", { clear = true }),
    callback = function()
      rest_colors()
    end,
  })
end

local default_header = {
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
      { { "NeovimDashboardLogo1", 6, 8 }, { "NeovimDashboardLogo3", 9, 22 } },
      {
        { "NeovimDashboardLogo1", 6, 8 },
        { "NeovimDashboardLogo2", 9, 11 },
        { "NeovimDashboardLogo3", 12, 24 },
      },
      { { "NeovimDashboardLogo1", 6, 11 }, { "NeovimDashboardLogo3", 12, 26 } },
      { { "NeovimDashboardLogo1", 6, 11 }, { "NeovimDashboardLogo3", 12, 24 } },
      { { "NeovimDashboardLogo1", 6, 11 }, { "NeovimDashboardLogo3", 12, 22 } },
      { { "", 0, 0 } },
      { { "", 0, 0 } },
      { { "NeovimDashboardLogo4", 0, 8 }, { "NeovimDashboardLogo5", 9, 17 } },
    },
    -- wrap = "overflow";
  },
}

local pacman =
  "󰮯·············································󱙝󰊠󱙝"

local full_version = " "
  .. vim.version().major
  .. "."
  .. vim.version().minor
  .. "."
  .. vim.version().patch
  .. "                         "
  .. "idea from nvchad 󱍄"

local footer = {
  type = "text",
  val = { pacman, full_version },
  opts = {
    position = "center",
    hl = "Number",
  },
}

local leader = "Spc"

--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
  local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

  local opts = {
    position = "center",
    shortcut = sc,
    cursor = 3,
    width = 50,
    align_shortcut = "right",
    hl_shortcut = "Keyword",
  }
  if keybind then
    keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
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

local buttons = {
  type = "group",
  val = {
    button("Spc bn", " New Buffer"),
    button("Spc sp", " Find Files"),
    button("Spc sr", " Old Files"),
    button("Spc st", "󰮗 Live Grep"),
    button("Spc sP", " Recent Projects"),
    button("Spc  q", "󰗽 Quit"),
  },
  opts = {
    spacing = 1,
  },
}

local section = {
  terminal = default_terminal,
  header = default_header,
  buttons = buttons,
  footer = footer,
}

local M = {
  layout = {
    { type = "padding", val = 2 },
    section.header,
    { type = "padding", val = 2 },
    section.buttons,
    section.footer,
  },
  opts = {
    margin = 5,
  },
  init = init,
}

return M
