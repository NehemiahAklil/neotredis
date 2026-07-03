# Plugin Documentation

Reference for the plugins added in Stage 3 of the DX audit (see `PLAN.md`):
what each one does and the keymaps/commands it adds. Grouped by the PR that
introduced them.

## Stage 3a — LSP & snacks.nvim

### `folke/lazydev.nvim`

Configures `lua_ls` with accurate types for the Neovim API and any plugin
under `lazy`'s package path, so completion/hover/diagnostics inside this
config (and other Lua Neovim configs) understand `vim.*` and plugin APIs
without manually maintaining a `.luarc.json`. Lazy-loaded on `ft = "lua"`.

No keymaps — it's a pure LSP/completion backend. It registers an `nvim-cmp`
source (`lazydev`, `group_index = 0`) that suppresses `lua_ls`'s own
duplicate `require(...)` completions in favor of its own.

### `lua_ls` (via `mason-lspconfig`)

The Lua language server, now installed automatically through Mason and
enabled in `lua/neotredis/plugins/lsp.lua` alongside the other configured
servers (`gopls`, `html`, `ts_ls`, `emmet_ls`, `vue_ls`, `pyright`). Standard
LSP keymaps (hover, go-to-definition, etc.) are the Neovim 0.11+ defaults set
up in `autocmd.lua`'s `LspAttach`.

### `folke/snacks.nvim` (first-class spec)

Previously only pulled in transitively by `claudecode.nvim` and
`opencode.nvim` (which use `Snacks.picker.select` for their model/effort
pickers). Now has its own spec at `lua/neotredis/plugins/snacks.lua` with
these modules enabled:

| Module | What it does |
|---|---|
| `notifier` | Replaces `vim.notify` with Snacks' floating notification UI. |
| `bigfile` | Detects large files and disables slow features (treesitter, LSP) to keep them responsive. |
| `words` | Auto-highlights and lets you jump between references of the word under the cursor (LSP-based). |
| `quickfile` | Speeds up rendering the first file on startup, before plugins fully load. |
| `picker` | Snacks' built-in fuzzy picker framework — available for other plugins to hook into (as claudecode/opencode already do). |
| `zen` | Distraction-free writing/coding mode. |

`dashboard` and `terminal` modules are **explicitly disabled** — `dashboard-nvim`
and `FTerm.nvim` still own those roles until Stage 4 replaces them; running
both sets side-by-side would double-fire on `VimEnter` or collide on toggle
keymaps.

**Keymaps:**

| Key | Action |
|---|---|
| `<leader>zz` | Toggle Zen Mode |
| `<leader>zZ` | Toggle Zoom (maximize current window) |

These don't collide with `true-zen.nvim`'s existing `<leader>zn/zf/zm/za`.
