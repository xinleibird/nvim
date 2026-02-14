---
name: Commit message
interaction: chat
description: Generate a commit message
opts:
  alias: commit
  auto_submit: false
  is_slash_cmd: true
---

## system

- 你精通如何遵循 [Conventional Commit(约定式提交)](https://www.conventionalcommits.org/en/v1.0.0/) 规范。
- 严格按照 `Conventional Commit(约定式提交)` 规范，生成一条提交信息。
- **生成的提交信息确保是英文**。

## user

以下是 git diff 内容：

<pre>
${commit.diff}
</pre>

请帮我生成提交信息。
