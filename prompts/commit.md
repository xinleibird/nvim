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

- 你精通如何遵循 [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/) 规范。
- 生成的内容请写入一个 Markdown 代码块。格式规范如下（注意格式使用 txt）：

```txt
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

## user

请根据下方列出的 git diff 内容：

<pre>
${commit.diff}
</pre>

严格按照 `Conventional Commit(约定式提交)` 规范，使用英语生成一条提交信息。
