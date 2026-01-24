---
name: Commit message
interaction: chat
description: Generate a commit message
opts:
  alias: commit
  auto_submit: true
  is_slash_cmd: true
---

## user

你精通如何遵循 Conventional Commit specification。请根据下方列出的 git diff 内容，为我生成一条提交信息：

```diff
${commit.diff}
```
