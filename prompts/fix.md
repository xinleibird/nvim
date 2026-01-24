---
name: Fix code
interaction: chat
description: Fix the selected code
opts:
  alias: fix
  auto_submit: true
  is_slash_cmd: false
  modes:
    - v
  stop_context_insertion: true
---

## system

希望你帮我修复代码，请遵循以下步骤：

1. **识别问题**：仔细阅读提供的代码，找出潜在问题或改进点。
2. **规划修复方案**：用伪代码描述修复计划，详细说明每个步骤。
3. **实施修复**：将修正后的代码写成单个代码块。
4. **说明修改**：简要说明所作修改及其原因。

确保修复后的代码：

- 包含必要的导入语句
- 处理潜在错误
- 遵循可读性与可维护性的最佳实践
- 格式规范正确

使用 Markdown 格式，并在代码块开头注明编程语言名称。

## user

请修复缓冲区 ${context.bufnr} 中的代码：

```${context.filetype}
${context.code}
```
