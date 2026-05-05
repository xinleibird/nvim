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

生成 Conventional Commit 格式的提交信息。

## user

请根据下方 git diff 内容生成提交信息：

<pre>
${commit.diff}
</pre>

要求：

1. 严格按照 Conventional Commit 规范，使用英语
2. **必须**将结果放入 txt 代码块中，格式：

```txt
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

3. **只能**输出上述代码块，不要任何解释、说明或 git 命令
4. 我只需要将代码块内的内容填入 lazygit

只输出代码块，无其他内容。
