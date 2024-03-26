local M = {}

M.generate_grey_logo = function(dashboard)
  local banners = {
    {
      [[                                                            ]],
      [[                          ███████████                       ]],
      [[                      ████           ████                   ]],
      [[                    ██                   ██                 ]],
      [[                  ██                       ██               ]],
      [[                  ██  ██  ██               ██               ]],
      [[                ██    ██  ██         ████    ██             ]],
      [[                ██                 ██    ██  ██             ]],
      [[                ██  ▒▒  ▒▒  ▒▒           ██  ██             ]],
      [[                ██  ▒▒▒▒▒▒▒▒▒▒░░               ██           ]],
      [[                  ██  ▒▒  ▒▒  ▒▒             ██             ]],
      [[                    ██                   ████               ]],
      [[                      ██████         ████                   ]],
      [[                            █████████                       ]],
      [[                                                            ]],
    },
    {
      [[                                                            ]],
      [[                          █████████                         ]],
      [[                      ████▒▒▒▒▒▒▒▒▒████                     ]],
      [[                    ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                   ]],
      [[                  ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                 ]],
      [[                 █▒▒▒▒▒█▒▒    ▒▒▒▒▒▒▒▒▒    █                ]],
      [[                ██▒▒▒▒▒▒  ▒▒▓▓  ▒▒▒▒▒  ▒▒▓▓ █               ]],
      [[                █▒▒▒▒▒▒▒  ▒▒▓▓  ▒▒▒▒▒  ▒▒▓▓ █               ]],
      [[                █▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒▒    █                ]],
      [[               █▒▒▒▒▒▒▒▒█▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒█               ]],
      [[              █▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█              ]],
      [[             █▒▒▒▒████▒▒▒▒▒▒████▒▒▒▒▒▒████▒▒▒▒█             ]],
      [[            ██▒▒██    ██▒▒██    ██▒▒██    ██▒▒██            ]],
      [[              ██        ██        ██        ██              ]],
      [[                                                            ]],
    },
    {
      [[                                                            ]],
      [[                                                            ]],
      [[                 ▄▄▄▄▄▒█████████████████▒▄▄▄▄▄              ]],
      [[               ▄▒█████████▀▀▀▀▀▀▀▀▀▀██████▀███▒▄            ]],
      [[             ▄▒█▀████████▄             ▀▀████ ▀█▒▄          ]],
      [[            ▀▒█▄▄██████████████████▄▄▄         ▄█▒▀         ]],
      [[              ▀▒████████████████████████▄    ▄█▒▀           ]],
      [[                ▀▒███▀▀▀▀▀▀▀▀▀▀▀▀█████████▄▄█▒▀             ]],
      [[                  ▀▒██▄              ▀█████▒▀               ]],
      [[                    ▀▒█████▄         ▄███▒▀                 ]],
      [[                       ▀▒████▄▄▄▄▄▄▄██▒▀                    ]],
      [[                         ▀▒███▀▀▀███▒▀                      ]],
      [[                           ▀▒██▄██▒▀                        ]],
      [[                              ▀▒▀                           ]],
      [[                                                            ]],
    },
    {
      [[                                                            ]],
      [[                                                            ]],
      [[                                                            ]],
      [[                      ▀████▀▄▄              ▄█              ]],
      [[                        █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█              ]],
      [[                █▄       █          ▀▀▀▀▄  ▄▀               ]],
      [[               ▄▀ ▀▄      ▀▄              ▀▄▀               ]],
      [[              ▄▀    █     █▀   ▄█▀▄      ▄█                 ]],
      [[              ▀▄     ▀▄  █     ▀██▀     ██▄█                ]],
      [[               ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █               ]],
      [[                █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀               ]],
      [[               █   █  █      ▄▄           ▄▀                ]],
      [[                                                            ]],
      [[                                                            ]],
      [[                                                            ]],
    },
    {
      [[                          ▄▄████▄▄                          ]],
      [[                        ▄██████████▄                        ]],
      [[                      ▄██▄██▄██▄██▄██▄                      ]],
      [[                        ▀█▀  ▀▀  ▀█▀                        ]],
      [[                                                            ]],
      [[    ▀▄   ▄▀     ▄ ▀▄   ▄▀ ▄       ▀▄   ▄▀        ▀▄   ▄▀    ]],
      [[   ▄█▀███▀█▄    █▄███████▄█      ▄█▀███▀█▄      ▄█▀███▀█▄   ]],
      [[  █▀███████▀█   ███▄███▄███     █▀███████▀█    █▀███████▀█  ]],
      [[  █ █▀▀▀▀▀█ █   ▀█████████▀     █ █▀▀▀▀▀█ █    █ █▀▀▀▀▀█ █  ]],
      [[     ▀▀ ▀▀       ▄▀     ▀▄         ▀▀ ▀▀          ▀▀ ▀▀     ]],
      [[     ▄██▄         ▄▄████▄▄          ▄██▄         ▄▄████▄▄   ]],
      [[   ▄██████▄      ██████████       ▄██████▄      ██████████  ]],
      [[  ███▄██▄███     ██▄▄██▄▄██      ███▄██▄███     ██▄▄██▄▄██  ]],
      [[    ▄▀▄▄▀▄        ▄▀▄▀▀▄▀▄         ▄▀▄▄▀▄        ▄▀▄▀▀▄▀▄   ]],
      [[   ▀ ▀  ▀ ▀      ▀        ▀       ▀ ▀  ▀ ▀      ▀        ▀  ]],
    },
    {
      [[                                                            ]],
      [[                          ▄▄▄▄▄▄▄▄▄                         ]],
      [[                        ▒███████████▒                       ]],
      [[                ▒████▄  ▀███▄   ▄███▀  ▄████▒               ]],
      [[                ▐██▒███▄  ▀███▄███▀  ▄███▒██▌               ]],
      [[                 ▒██▄▀███▄  ▀███▀  ▄███▀▄██▒                ]],
      [[                 ▐█▄▀█▄▀██▒ ▄ ▀ ▄ ▒██▀▄█▀▄█▌                ]],
      [[                  ▒██▄▀███▒ ██▄██ ▒███▀▄██▒                 ]],
      [[                    ▀▀▀▀▀▀   █▒█   ▀▀▀▀▀▀▀                  ]],
      [[                  ▒█▄     ▄█ █▒█ █▄     ▄█▒                 ]],
      [[                   ▀█▒█ █▒█████████▒█ █▒█▀                  ]],
      [[                     ▀█ █▒█ ▄▄▄▄▄ █▒█ █▀                    ]],
      [[                        ▀▒▌▐█▒▒▒█▌▐▒▀                       ]],
      [[                           ▒█▒▒▒█▒                          ]],
      [[                                                            ]],
    },
    {
      [[                                                            ]],
      [[                                                            ]],
      [[                                                            ]],
      [[                                                            ]],
      [[  ███▄    ██  ▓█████   ▒█████    ██▒    █▓  ██▓  ███▄ ▄███▓ ]],
      [[ ▓██ ▀█   █   ▓█   ▀  ▒██▒  ██▒ ▓██░   ██▒ ▓██▒ ▓██▒▀█▀ ██▒▒]],
      [[ ▓██  ▀█ ██▒ ▒▒███    ▒██░  ██▒  ▓██  ██▒░ ▒██▒ ▓██    ▓██░░]],
      [[ ▓██▒  ▐▌██▒ ▒▒▓█  ▄  ▒██   ██░   ▒██ ██░░ ░██░ ▒██    ▒██  ]],
      [[▒▒██░   ▓███ ░░▒████ ▒░ ████▓▒░    ▒▀█░░   ░██░ ▒██▒   ░██▒ ]],
      [[░░ ▒░   ▒ ▒▒  ░░ ▒░  ░░ ▒░▒░▒░     ░ ▐░░   ░▓   ░ ▒░   ░  ░ ]],
      [[ ░ ░░   ░ ▒▒ ░ ░ ░   ░  ░ ▒ ▒░     ░ ░ ░    ▒ ░ ░  ░      ░ ]],
      [[    ░   ░ ░░     ░    ░ ░ ░ ▒        ░░     ▒ ░ ░      ░    ]],
      [[          ░░     ░   ░    ░ ░         ░     ░          ░    ]],
      [[                                     ░                      ]],
      [[                                                            ]],
    },
  }
  dashboard.section.header.val = banners[math.random(1, #banners)]
  dashboard.section.header.opts = { position = "center", hl = "AlphaHeader" }
end

M.generate_small_logo = function(dashboard)
  local reset_colors = function()
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

  reset_colors()

  vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = vim.api.nvim_create_augroup("user_small_logo_reset", { clear = true }),
    callback = function()
      reset_colors()
    end,
  })

  dashboard.section.header.val = {
    [[]],
    [[]],
    [[]],
    [[]],
    [[     █  █     ]],
    [[     ██ ██     ]],
    [[     █████     ]],
    [[     ██ ███     ]],
    [[     █  █     ]],
    [[]],
    [[N  E  O   V  I  M]],
    [[]],
    [[]],
    [[]],
    [[]],
  }

  dashboard.section.header.opts.hl = {
    { { "", 0, 0 } },
    { { "", 0, 0 } },
    { { "", 0, 0 } },
    { { "", 0, 0 } },
    { { "NeovimDashboardLogo1", 5, 7 }, { "NeovimDashboardLogo3", 8, 24 } },
    {
      { "NeovimDashboardLogo1", 5, 7 },
      { "NeovimDashboardLogo2", 8, 12 },
      { "NeovimDashboardLogo3", 13, 24 },
    },
    { { "NeovimDashboardLogo1", 5, 10 }, { "NeovimDashboardLogo3", 11, 24 } },
    { { "NeovimDashboardLogo1", 5, 10 }, { "NeovimDashboardLogo3", 11, 24 } },
    { { "NeovimDashboardLogo1", 5, 10 }, { "NeovimDashboardLogo3", 11, 24 } },
    { { "", 0, 0 } },
    { { "NeovimDashboardLogo4", 0, 8 }, { "NeovimDashboardLogo5", 9, 18 } },
    { { "", 0, 0 } },
    { { "", 0, 0 } },
    { { "", 0, 0 } },
    { { "", 0, 0 } },
  }
end

M.generate_big_logo = function(dashboard)
  local logo = {
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
  }
  dashboard.section.header.val = logo

  local colors = {
    ["b"] = { fg = "#3399ff", ctermfg = 33, bold = true },
    ["a"] = { fg = "#53C670", ctermfg = 35 },
    ["g"] = { fg = "#39ac56", ctermfg = 29 },
    ["h"] = { fg = "#33994d", ctermfg = 23 },
    ["i"] = { fg = "#33994d", bg = "#39ac56", ctermfg = 23, ctermbg = 29 },
    ["j"] = { fg = "#53C670", bg = "#33994d", ctermfg = 35, ctermbg = 23 },
    ["k"] = { fg = "#30A572", ctermfg = 36 },
  }

  local color_names = {}
  local reset_colors = function()
    for key, color in pairs(colors) do
      local name = "Alpha" .. key
      vim.api.nvim_set_hl(0, name, color)
      ---@diagnostic disable-next-line: assign-type-mismatch
      color_names[key] = name
    end
  end
  reset_colors()

  vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = vim.api.nvim_create_augroup("user_big_logo_reset", { clear = true }),
    callback = function()
      reset_colors()
    end,
  })

  dashboard.section.header.opts.hl = {}

  -- helper function for utf8 chars
  local function get_char_len(s, pos)
    local byte = string.byte(s, pos)
    if not byte then
      return nil
    end
    return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
  end

  local logo_temple = {
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
  }

  for i, line in ipairs(logo_temple) do
    local highlights = {}
    local pos = 0

    for j = 1, #line do
      local opos = pos
      pos = pos + get_char_len(logo[i], opos + 1)

      local color_name = color_names[line:sub(j, j)]
      if color_name then
        table.insert(highlights, { color_name, opos, pos })
      end
    end

    table.insert(dashboard.section.header.opts.hl, highlights)
  end
end

return M
