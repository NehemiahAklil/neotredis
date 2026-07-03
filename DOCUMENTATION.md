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

## Stage 3b — Motion & diagnostics UI

### `folke/flash.nvim`

Label-based jump motion: type `s` (or `S` for a treesitter-node picker),
then a couple of characters, and every match on screen gets a label to jump
to instantly. Works in normal, visual, and operator-pending modes, so it
composes with operators (e.g. `ds<label>` deletes up to a jump target).

**Keymaps:**

| Key | Mode | Action |
|---|---|---|
| `s` | normal, visual, operator-pending | Jump to a labeled match |
| `S` | normal, visual, operator-pending | Jump via treesitter-node selection |
| `r` | operator-pending | Remote flash (act on a target without moving the cursor there) |
| `R` | operator-pending, visual | Treesitter search |
| `<c-s>` | command-line | Toggle Flash search while typing `/` or `?` |

### `folke/trouble.nvim`

A persistent, navigable list for diagnostics, LSP symbols, references, and
the location/quickfix lists — replaces jumping through `[d`/`]d` one at a
time when there are many issues to triage. `mini.indentscope` already
excludes Trouble's filetype (see `lua/neotredis/plugins/indentscope.lua`).

**Keymaps:**

| Key | Action |
|---|---|
| `<leader>xx` | Toggle diagnostics (workspace) |
| `<leader>xX` | Toggle diagnostics (current buffer only) |
| `<leader>xs` | Toggle symbols outline |
| `<leader>xl` | Toggle LSP definitions/references (right split) |
| `<leader>xL` | Toggle location list |
| `<leader>xQ` | Toggle quickfix list |

### `folke/todo-comments.nvim`

Highlights `TODO`, `FIX`/`FIXME`, `HACK`, `WARN`, `NOTE`, etc. comments and
lets you navigate and list them, feeding into Trouble and Telescope for a
full project-wide view.

**Keymaps:**

| Key | Action |
|---|---|
| `]t` | Jump to next todo comment |
| `[t` | Jump to previous todo comment |
| `<leader>xt` | Open all todo comments in Trouble |
| `<leader>xT` | Open only TODO/FIX/FIXME comments in Trouble |
| `<leader>ft` | Open todo comments in Telescope |

## Stage 3c — Git

Rounds out git tooling. The porcelain (staging/committing) is handled by
`lazygit` via `snacks.nvim`; `vim-fugitive` (`<leader>gs`) and
`git-conflict.nvim` were already present.

### `lewis6991/gitsigns.nvim`

Shows per-line git status in the sign column and inline blame on the current
line. Now wired with the standard hunk workflow via `on_attach`.

**Keymaps:**

| Key | Mode | Action |
|---|---|---|
| `]h` / `[h` | normal | Next / previous hunk (falls back to `]c`/`[c` in diff mode) |
| `<leader>hs` | normal, visual | Stage hunk (or selected lines) |
| `<leader>hr` | normal, visual | Reset hunk (or selected lines) |
| `<leader>hS` | normal | Stage entire buffer |
| `<leader>hR` | normal | Reset entire buffer |
| `<leader>hu` | normal | Undo last stage hunk |
| `<leader>hp` | normal | Preview hunk inline |
| `<leader>hb` | normal | Blame current line (full) |
| `<leader>hd` | normal | Diff current buffer against index |
| `ih` | operator, visual | Select-hunk text object (e.g. `vih`, `dih`) |

### `sindrets/diffview.nvim`

Single-tabpage diff, full file/branch history, and a 3-way merge-conflict view.
Lazy-loaded on its `:Diffview*` commands.

**Keymaps:**

| Key | Action |
|---|---|
| `<leader>gdo` | Open diff of the working tree |
| `<leader>gdc` | Close the diffview tab |
| `<leader>gdh` | File history for the whole repo |
| `<leader>gdf` | File history for the current file |

### `isakbm/gitgraph.nvim`

Draws the commit graph — branches, forks, diverges, merges, rebases — as line
graphs in a buffer. Selecting a commit (or a visual range) opens the
corresponding diff in `diffview.nvim`.

**Keymaps:**

| Key | Action |
|---|---|
| `<leader>gl` | Draw the git graph (all branches) |

### `folke/snacks.nvim` (git helpers)

Wired from the existing `snacks.nvim` spec — no extra dependency.

**Keymaps:**

| Key | Mode | Action |
|---|---|---|
| `<leader>gg` | normal | Open Lazygit (full git TUI) |
| `<leader>gB` | normal, visual | Open current line/selection in the git remote (browser) |
