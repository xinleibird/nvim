---
name: Commit message
interaction: chat
description: Generate a commit message
opts:
  alias: commit
  auto_submit: false
  is_slash_cmd: true
  stop_context_insertion: true
---

## system

- 你精通如何遵循 Conventional Commit 规范。
- 要推送的 GitHub，因此**生成的提交信息应该确保是英文**的。
- 生成的内容请使用英文。
- 生成的内容请写入一个 Markdown 代码块。格式规范如下：

```txt
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## user

请根据下方列出的 git diff 内容，使用英语生成一条提交信息：

```diff
${commit.diff}
```
