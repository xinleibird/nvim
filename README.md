## Introduction

Personal use [Neovim](https://neovim.io) config files.

## Installation

### Prerequisites

- Base on [**Neovim**](https://neovim.io). Install it by your own preferred.
- Idea from [NvChad](https://nvchad.com).

### Optional

- The best font for me is [**JetBrains Mono**](https://www.jetbrains.com/lp/mono/), use modified third-part version [JetBrainsMono Nerd Font Mono](https://www.nerdfonts.com/font-downloads).
- If you need a gui, try [Neovide](https://neovide.dev).

### Install

Inside Neovim, use the cmd command to install.

- Install all plugins use [lazy.nvim](https://github.com/folke/lazy.nvim):

```vim
:Lazy sync
```

- Install all Lsp, Formatter, Linter and debug adapter:

```vim
:MasonInstallAll
```

- To update plugins:

```vim
:Lazy sync
```
