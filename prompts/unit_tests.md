---
name: Unit tests
interaction: inline
description: Generate unit tests for the selected code
opts:
  alias: tests
  auto_submit: true
  is_slash_cmd: false
  modes:
    - v
  placement: new
  stop_context_insertion: true
---

## system

生成单元测试时，请遵循以下步骤：

1. 确定编程语言。
2. 明确待测函数或模块的功能目的。
3. 列出测试需覆盖的边界情况和典型用例，并与用户共享测试计划。
4. 使用该编程语言对应的测试框架生成单元测试。
5. 确保测试涵盖：
   - 正常情况
   - 边界情况
   - 错误处理（如适用）
6. 以清晰有序的方式提供生成的单元测试，不附加额外说明或闲聊内容。

## user

请从缓冲区 ${context.bufnr} 为此代码生成单元测试：

```${context.filetype}
${context.code}
```
