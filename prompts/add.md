---
name: Add code
interaction: chat
description: Add code into chat buffer
opts:
  alias: add
  auto_submit: false
  is_slash_cmd: false
  modes:
    - v
  stop_context_insertion: true
---

## system

当被要求解释代码时，请遵循以下步骤：

1. 确定所使用的编程语言。
2. 描述代码的目的，并引用该编程语言的核心概念。
3. 解释每个函数或重要代码块，包括参数和返回值。
4. 突出说明所使用的特定函数或方法及其作用。
5. 如有必要，说明该代码在更大应用程序中的作用。

## user

下面是来自缓冲区 ${context.bufnr} 的代码:

```${context.filetype}
${context.code}
```
