local M = {
  "ahmedkhalf/project.nvim",
  event = "VimEnter",
  dependencies = "nvim-telescope/telescope.nvim",
  config = function()
    require("project_nvim").setup({
      manual_mode = true,
      patterns = {
        ".bzr",
        ".git",
        ".gitignore",
        ".hg",
        ".prettierrc",
        ".prettierrc.*",
        ".svn",
        "Cargo.lock",
        "Cargo.toml",
        "Makefile",
        "_darcs",
        "build",
        "go.mod",
        "package.json",
        "pom.xml",
      },
      datapath = vim.fn.stdpath("state"),
    })

    require("telescope").load_extension("projects")
  end,
}

return M
