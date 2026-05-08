# OpenCode Agent 指南 - Neovim 配置

本指南旨在帮助 OpenCode 代理快速理解此 Neovim 配置仓库的结构与约定。

## 核心架构
- **入口点**: `init.lua` 负责加载所有核心配置。
- **环境隔离**:
  - `if vim.g.vscode`: 针对 VSCode-Neovim 扩展的轻量加载。
  - `if vim.g.neovide`: 针对 Neovide GUI 的特定设置。
- **配置组织**:
  - `lua/configs/`: 核心设置（options, lazy, mappings, autocmds, lsp）。
  - `lua/plugins/`: 插件定义的单文件 Spec。
  - `lua/utils/`: 通用工具函数。
- **插件管理**: 使用 `lazy.nvim`。插件列表通过 `require("lazy").setup({ spec = { { import = "plugins" } } })` 动态加载 `lua/plugins/` 下的所有文件。

## 关键命令
代理在修改配置后，应建议用户运行以下命令以同步状态：
- `:Lazy sync` - 更新/同步所有插件。
- `:MasonInstallEnsured` - 安装预定义的 LSP、格式化工具、Linter（由 `lua/plugins/mason.lua` 定义）。
- `:TSInstallEnsured` - 安装预定义的 Tree-sitter 解析器（由 `lua/plugins/nvim-treesitter.lua` 定义）。

## 开发约定
- **LSP 启用**: 并非所有 LSP 都通过 `nvim-lspconfig` 的 `setup` 调用。此仓库使用 `vim.lsp.enable({ ... })` 在 `lua/configs/lsp.lua` 中批量激活。
- **格式化**: 使用 `conform.nvim` 管理。
  - 大多数前端/配置文件使用 `oxfmt`。
  - Lua 使用 `stylua`。
  - Shell 使用 `shfmt`。
  - 保存时自动格式化已启用。
- **路径注入**: `lua/configs/options.lua` 会自动将 Mason 的 `bin` 目录注入到系统 `PATH` 中。
- **Lua 模块**: 在 `lua/plugins/` 下编写新插件 Spec 时，务必包含 `---@module "lazy"` 和 `---@type LazySpec` 注解。

## 避坑指南
- **不要**在 `lua/plugins/` 之外手动加载插件。
- **不要**直接在 `init.lua` 中添加大量配置，应按功能模块放入 `lua/configs/`。
- **注意**: `vim.g.mapleader` 设置为 ` ` (空格)，`vim.g.maplocalleader` 设置为 `\`。
- **Tree-sitter**: 复杂的语法高亮和折叠完全依赖 Tree-sitter。如果高亮失效，检查对应的 parser 是否已安装。
