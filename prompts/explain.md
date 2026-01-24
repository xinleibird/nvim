---
name: Explain code
interaction: chat
description: Explain how code in a buffer works
opts:
  alias: explain
  auto_submit: true
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

请对缓冲区 ${context.bufnr} 中包含的如下代码进行解释:

```${context.filetype}
${context.code}
```
