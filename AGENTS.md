# AGENTS.md

## Structure

- `init.lua` — entry point; loads configs in order: options → lazy → autocmds → mappings → lsp → filetypes
- `lua/configs/` — core configuration (options, keymaps, LSP, autocmds, etc.)
- `lua/plugins/` — one file per plugin, each returns a `LazySpec`; imported via `{ import = "plugins" }` in `lazy.lua`
- `lua/utils/` — shared utility functions (OS detection, buffer kill, etc.)
- `after/` — `lsp/` overrides per-language LSP settings; `ftplugin/` for filetype-specific config
- `dap/` — debug adapter configurations
- `snippets/` — VS Code-compatible snippet files, loaded by `babel.nvim`

## Plugin Manager

- Uses **lazy.nvim** (bootstrapped in `lua/configs/lazy.lua`)
- Plugin spec files are in `lua/plugins/` and auto-imported
- `lazy-lock.json` is **gitignored** — it's intentionally not version-controlled (unlike typical lazy.nvim setups)
- Install/update plugins: `:Lazy sync`

## Formatter & Style

- **stylua** for Lua formatting: indent 2 spaces, 120 column width, Unix line endings (see `.stylua.toml`)
- **conform.nvim** for format-on-save (configured per filetype in `lua/plugins/conform.lua`)
  - Most filetypes use `oxfmt`; Lua uses `stylua`; shell uses `shfmt`; vim/conf use custom `auto_indent`
  - Format-on-save is opt-out per buffer via `vim.b.disable_autoformat = true`
- `<leader>w` saves **with** format-on-save; `<leader>W` saves **without** formatting

## LSP & Tools

- LSP servers are enabled via `vim.lsp.enable({...})` in `lua/configs/lsp.lua`
- LSP config overrides go in `after/lsp/<server>.lua`
- Installed via Mason: `:MasonInstallEnsured`
- Linter: **nvim-lint** via `lua/plugins/nvim-lint.lua`; formatter: **conform.nvim**
- Tree-sitter: `:TSInstallEnsured`

## Key Context for Editing Config Files

- Leader is `<space>` (`vim.g.mapleader = " "`)
- All `lua/plugins/*.lua` return a `---@type LazySpec` table; do NOT call `require("lazy").setup()` inside them
- `after/lsp/*.lua` return a `---@type vim.lsp.Config` table (used with `vim.lsp.enable`)
- The `neovide.lua` config only loads when `vim.g.neovide` is set (Neovide GUI)
- VSCode-Neovim: when `vim.g.vscode` is truthy, `init.lua` loads only `vscode.vim` and returns early

## AI Tools

- **codecompanion.nvim** uses both `opencode` (default agent) and `gemini` CLI backends
- Prompt templates live in `prompts/` (markdown) and are auto-discovered from `~/.config/nvim/prompts`
- CodeCompanion keymaps: `<leader>a` prefix (aa=chat, af=fix, ae=explain, al=lsp, aw=workflow, ac=cli, aP=actions)

## System Dependencies

Required CLI tools (not installed by Neovim):

- `fzf`, `ripgrep`, `fd` — for Snacks picker and grep
- `imagemagick`, `ghostscript` — image/PDF support
- `chafa` — GIF preview in dashboard
- `opencode-ai` — CodeCompanion CLI adapter

## Editing Dos & Don'ts

- DON'T run `:Lazy clean` without understanding which plugins are intentionally pinned
- DON'T change `{ import = "plugins" }` in `lua/configs/lazy.lua` — it auto-discovers all plugin specs
- DO restart Neovim or run `:Lazy reload` after editing plugin specs
- Tab/indent = 2 spaces (enforced by stylua and `vim.o` defaults)

