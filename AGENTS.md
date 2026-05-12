# Neovim 配置

## 结构

- `init.lua` - 入口点。按顺序加载配置：options、lazy、autocmds、mappings、lsp、filetypes
- `lua/configs/` - 核心配置模块
- `lua/plugins/` - 44 个插件规格（lazy.nvim 格式）
- `lua/utils/init.lua` - 共享工具（系统检测、深色模式、缓冲区操作）
- `after/` - ftplugin 和 LSP 重写

## 代码风格

- **格式化工具**: stylua (`.stylua.toml`)
  - 2 空格缩进，120 列宽度，优先使用双引号
- **Lua**: 5.1 兼容（nvim 内置）
- 插件规格使用 `---@module "lazy"` 和 `---@type LazySpec` 注解

## 加载顺序

```
init.lua → configs/options.lua → configs/lazy.lua (引导 lazy) →
configs/autocmds.lua → configs/mappings.lua → configs/lsp.lua → configs/filetypes.lua
```

## 特殊情况

- **VSCode-Neovim**: `init.lua` 检测 `vim.g.vscode` 并加载 `vscode.vim`
- **Neovide**: `vim.g.neovide` 触发 `configs/neovide.lua`
- **深色模式**: 通过 macOS `AppleInterfaceStyle` 自动检测

## 添加插件

1. 使用 lazy.nvim 规格格式创建 `lua/plugins/<name>.lua`
2. 使用 `dependencies = {}` 声明插件依赖
3. 使用 `init = function()` 运行插件加载前的代码
4. 使用 `config = function()` 在插件加载后进行配置
5. 在 nvim 中运行 `:Lazy sync` 安装

