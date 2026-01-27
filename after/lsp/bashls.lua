---@brief
---
--- https://github.com/bash-lsp/bash-language-server
---
--- `bash-language-server` can be installed via `npm`:
--- ```sh
--- npm i -g bash-language-server
--- ```
---
--- Language server for bash, written using tree sitter in typescript.

---@type vim.lsp.Config
return {
  cmd = { "bash-language-server", "start" },
  settings = {
    bashIde = {
      -- Glob pattern for finding and parsing shell script files in the workspace.
      -- Used by the background analysis features across files.

      -- Prevent recursive scanning which will cause issues when opening a file
      -- directly in the home directory (e.g. ~/foo.sh).
      --
      -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
      globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
      shellcheckArguments = "--shell=bash", -- 强制 shellcheck 按 bash 逻辑处理，通常能覆盖大部分 zsh 语法
    },
  },
  filetypes = { "bash", "sh", "zsh" },
  root_markers = { ".git" },
  single_file_support = true,
}
