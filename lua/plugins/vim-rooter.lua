local M = {
  "airblade/vim-rooter",
  event = "BufRead",
  -- enabled = false,
  init = function()
    vim.g.rooter_patterns = {
      -- exclude
      "!=snippets/",

      -- directories
      "client",
      "server",

      -- version control systems
      "_darcs",
      ".hg",
      ".bzr",
      ".svn",
      ".git",

      -- build tools
      "*.sln",
      "Makefile",
      "CMakeLists.txt",
      "build.gradle",
      "build.gradle.kts",
      "pom.xml",
      "build.xml",

      -- node.js and javascript
      "package.json",
      "package-lock.json",
      "yarn.lock",
      ".nvmrc",
      "gulpfile.js",
      "Gruntfile.js",

      -- python
      "requirements.txt",
      "Pipfile",
      "pyproject.toml",
      "setup.py",
      "tox.ini",

      -- rust
      "Cargo.toml",

      -- go
      "go.mod",

      -- elixir
      "mix.exs",

      -- configuration files
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.yaml",
      ".prettierrc.yml",
      ".eslintrc",
      ".eslintrc.json",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintignore",
      ".stylelintrc",
      ".stylelintrc.json",
      ".stylelintrc.yaml",
      ".stylelintrc.yml",
      ".editorconfig",
      ".gitignore",

      -- html projects
      "index.html",

      -- miscellaneous
      "README.md",
      "README.rst",
      "LICENSE",
      "Vagrantfile",
      "Procfile",
      ".env",
      ".env.example",
      "config.yaml",
      "config.yml",
      ".terraform",
      "terraform.tfstate",
      ".kitchen.yml",
      "Berksfile",

      -- rime library location
      "squirrel.yaml",
      "weasel.yaml",

      -- zk notes
      ".zk/",
    }

    -- a literal / to match directory buffers, a star * to match file buffers. disable directory buffers for snacks.explorer. default is {"/", "*"}
    vim.g.rooter_targets = { "*" }
    vim.g.rooter_silent_chdir = 1

    vim.api.nvim_create_autocmd("DirChanged", {
      pattern = "*",
      group = vim.api.nvim_create_augroup("user_rooter_chdir", { clear = true }),
      callback = function()
        local cwd = vim.fn.getcwd()
        local file = io.open(vim.fn.stdpath("cache") .. "/rooter_last_dir", "w")
        if file then
          file:write(cwd)
          file:close()
        end
      end,
    })
  end,
}

return M
