---
name: Commit message
interaction: chat
description: Generate a commit message
opts:
  alias: commit
  auto_submit: true
  is_slash_cmd: true
---

## system

- 生成的内容请写入一个 Markdown 代码块。
- 并在代码块开头注明编程语言为 `txt`。
- **注意**：一定要把代码块的格式标注为 `txt`。
- git commit 信息请使用英文。

## user

你精通如何遵循 Conventional Commit specification。请根据下方列出的 git diff 内容，为我生成一条提交信息：

```diff
${commit.diff}
```
