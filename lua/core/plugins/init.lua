local M = {

  -----------------------------------------------------------------------------
  -- Framework
  -----------------------------------------------------------------------------

  "nvim-lua/plenary.nvim",

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require("core.configs.treesitter")
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    opts = function()
      return require("core.configs.gitsigns")
    end,
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    dependencies = "neovim/nvim-lspconfig",
    opts = function()
      return require("core.configs.mason")
    end,
    config = function(_, opts)
      require("mason").setup(opts)

      -- custom cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "BufRead",
    config = function()
      require("core.configs.lspconfig").config()
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require("core.configs.luasnip")
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require("core.configs.cmp")
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = function()
      return require("core.configs.conform")
    end,
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "BufRead",
      dependencies = "numToStr/Comment.nvim",
      init = function()
        vim.g.skip_ts_context_commentstring_module = true
      end,
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("ts_context_commentstring").setup({
          enable_autocmd = false,
        })

        ---@diagnostic disable-next-line: missing-fields
        require("Comment").setup({
          pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        })
      end,
    },
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-telescope/telescope-ui-select.nvim",
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    cmd = "Telescope",
    opts = function()
      return require("core.configs.telescope")
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list or {}) do
        telescope.load_extension(ext)
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- UI
  -----------------------------------------------------------------------------

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require("core.configs.icons").devicons }
    end,
    config = function(_, opts)
      require("nvim-web-devicons").setup(opts)
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require("core.configs.nvimtree")
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },

  {
    "folke/which-key.nvim",
    -- keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    keys = { "<leader>", "<c-r>", '"', "'", "g" },
    cmd = "WhichKey",
    opts = function()
      return require("core.configs.whichkey")
    end,
    config = function(_, opts)
      require("which-key").setup(opts)
      require("which-key").register({
        b = { name = "+Buffers" },
        s = { name = "+Search" },
        l = { name = "+LSP" },
        g = { name = "+Git" },
        t = { name = "+Terminal" },
      }, { prefix = "<leader>" })
    end,
  },

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    init = function()
      require("core.configs.dashboard").init()
    end,
    opts = function()
      return require("core.configs.dashboard")
    end,
    config = function(_, opts)
      require("alpha").setup(opts)
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VimEnter",
    opts = function()
      return require("core.configs.lualine")
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
    end,
  },

  {
    "akinsho/bufferline.nvim",
    branch = "main",
    dependencies = {
      {
        "tiagovla/scope.nvim",
        lazy = false,
        config = function()
          require("scope").setup()
        end,
      },
    },
    event = "VimEnter",
    opts = function()
      return require("core.configs.bufferline")
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VimEnter",
    opts = {
      indent = { char = "▏", highlight = "IblIndent" },
      scope = { char = "▏", highlight = "IblScope" },
      whitespace = { highlight = "IblWhitespace" },
    },
    config = function(_, opts)
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    event = "VimEnter",
    version = "*",
    config = function()
      require("toggleterm").setup({
        highlights = {
          -- highlights which map to a highlight group name and a table of it's values
          -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
          Normal = {
            -- link = "Normal",
            link = "ToggleTermBg",
          },
          NormalFloat = {
            link = "ToggleTermBg",
          },
          SignColumn = {
            link = "ToggleTermBg",
          },
          -- FloatBorder = {
          --   guifg = "<VALUE-HERE>",
          --   guibg = "<VALUE-HERE>",
          -- },
        },
        winbar = {
          enabled = false,
          name_formatter = function(term) --  term: Terminal
            return term.name
          end,
        },
      })
    end,
  },
}
return M
