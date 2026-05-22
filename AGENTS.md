这里是 Neovim 配置

# 加载顺序

```
init.lua → options.lua → lazy.lua（引导 lazy.nvim）→
autocmds.lua → mappings.lua → lsp.lua → filetypes.lua
```

# 特殊情况

- **终端检测**: Kitty/Ghostty 自动识别 Super 键映射
- **深色模式**: 通过 `AppleInterfaceStyle`（macOS）自动检测，同步切换 Catppuccin 主题

# 代码风格

- **stylua**: 2 空格缩进，120 列宽，Unix 换行，优先双引号
- **Lua**: 5.1 兼容（nvim 内置），插件规格使用 `---@module "lazy"` / `---@type LazySpec` 注解

# LSP 配置

- LSP（在 `lua/configs/lsp.lua` 声明 + `after/lsp/` 覆盖）：
- 通过 Mason 管理二进制安装（`lua/plugins/mason.lua` 中 `MasonInstallEnsured` 命令）。

# 添加插件

1. 创建 `lua/plugins/<name>.lua`
2. 使用 `dependencies = {}` 声明插件依赖
3. 使用 `init = function()` 运行加载前代码
4. 使用 `config = function()` 进行插件配置
