---
name: Commit message
interaction: chat
description: Generate a commit message
opts:
  alias: commit
  auto_submit: true
  is_slash_cmd: true
  stop_context_insertion: true
---

## system

- 生成的内容请使用英文。
- 生成的内容请写入一个 Markdown 代码块。
- 并在代码块开头注明编程语言为 txt。
- 也就是说，在第三个 grave 符号之后，紧跟（不要换行）一个 txt 表示文件类型。示例如下：

```txt
feat(codecompanion): {title}

{content}

{footer}
```

## user

你精通如何遵循 Conventional Commit specification。请根据下方列出的 git diff 内容，为我生成一条 **英文** 提交信息：

```diff
${commit.diff}
```
