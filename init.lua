-- enable vim-plugin just for VSCode-Neovim
if vim.g.vscode then
  vim.cmd.runtime("./vscode.vim")
  return -- in vscode stop load
end

-- within Neovide
if vim.g.neovide then
  require("configs.neovide")
end

-- bootstrap lazy and all plugins
require("configs.lazy")
-- load options
require("configs.options")
-- load autocmds
require("configs.autocmds")
-- load mappings
require("configs.mappings")
-- load vim.lsp
require("configs.lsp")
-- load filetypes
require("configs.filetypes")
