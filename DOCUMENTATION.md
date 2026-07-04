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

## Stage 3d — Search/replace & text objects

Completes Stage 3 with the two remaining non-git additions.

### `MagicDuck/grug-far.nvim`

Project-wide, incremental search-and-replace over ripgrep, presented in a
dedicated buffer where you edit the search/replace/paths/flags and preview
matches live before applying. Lazy-loaded on `:GrugFar`.

**Keymaps:**

| Key | Mode | Action |
|---|---|---|
| `<leader>sr` | normal, visual | Open search & replace (visual seeds the search) |
| `<leader>sw` | normal | Open with the word under the cursor pre-filled |
| `<leader>sf` | normal | Open scoped to the current file |

### `nvim-mini/mini.ai`

Extends Neovim's `a`/`i` text objects with smarter, more numerous targets. The
built-in `f` (function call) and `a` (argument) objects give the motions from
the plan **without** treesitter-textobjects. Works in operator-pending and
visual modes.

**Text objects (use with any operator, e.g. `d`, `c`, `y`, `v`):**

| Object | Selects |
|---|---|
| `af` / `if` | A function **call** — `daf` deletes `foo(bar)`, `dif` its args |
| `aa` / `ia` | A function **argument** — `cia` changes the argument under cursor |
| `a)` `a]` `a}` | Balanced brackets (and `i` variants for inside) |
| `` a` `` `a"` `a'` | Quoted strings |
| `at` / `it` | HTML/XML tag |
| `a?` / `i?` | User-prompted region (type start/end on the fly) |

Prefix with a count (e.g. `2ia`) and use `n`/`l` (next/last) for the
`mini.ai`-specific `an`/`al` search behavior.

## Stage 5a — DAP core

First DAP addition (see `PLAN.md` Stage 5). Lays down the language-agnostic
debugger stack; per-language adapters (python, go, ts/js, vue/react, flutter)
land in follow-up PRs.

### `mfussenegger/nvim-dap` + `miroshQa/debugmaster.nvim`

`nvim-dap` is the Debug Adapter Protocol client — it talks to a per-language
debug adapter (configured separately) to set breakpoints, step, and inspect
state. `debugmaster.nvim` supplies the UI: a modal **DEBUG mode** (like
Insert/Normal, but for debugging) assembled from nvim-dap's own native
widgets, instead of a multi-window `dap-ui` layout. Also brings in
`jbyuki/one-small-step-for-vimkind` (`osv`), which lets DEBUG mode be
test-driven against this very Neovim/Lua config without any language adapter
configured yet.

> Note: debugmaster's own README quickstart snippet lists the plugin under a
> bogus GitHub owner (`MironPascalCaseFan/debugmaster.nvim`) — the real repo
> is `miroshQa/debugmaster.nvim`, which is what's pinned here.

**Keymaps (normal mode, outside DEBUG mode):**

| Key | Action |
|---|---|
| `<leader>d` | Toggle DEBUG mode |
| `<F5>` / `<leader>dc` | Continue / start debugging |
| `<F9>` / `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Set a conditional breakpoint (prompts for the condition) |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>dr` | Toggle the REPL |
| `<leader>dl` | Re-run the last debug config |
| `<leader>dt` | Terminate the debug session |

Inside DEBUG mode itself, debugmaster's own keymaps take over (`o` step over,
`m` step into, `q` step out, `r` run to cursor, `u`/`U` toggle panel/float,
`H` for help) — see the plugin's docs.

### `theHamsta/nvim-dap-virtual-text`

Shows variable values inline as virtual text while stepping through code —
genuinely nicer than VSCode's hover-to-inspect for a quick glance.

### `jay-babu/mason-nvim-dap.nvim`

Bridges `mason.nvim` (already used for LSP servers, see `lsp.lua`) with
`nvim-dap`, so debug adapters install the same way LSP servers do.
`ensure_installed` uses mason-nvim-dap's own dap-adapter names (not raw mason
package names — e.g. `"python"` maps to mason's `debugpy` package), and grows
as each language gets wired up (currently `{ "python", "delve" }`).

### `.vscode/launch.json` support

`nvim-dap` reads VSCode's own `launch.json` natively via
`require("dap.ext.vscode")` (auto-invoked on `dap.continue()`) — no extra
plugin needed. Projects that already ship VSCode debug configs get them for
free.

## Stage 5b — Python + Go adapters

Second DAP PR — wires the two simplest per-language adapters on top of
Stage 5a's core. TS/JS, Vue/React, and Flutter follow in later PRs.

### `mfussenegger/nvim-dap-python`

Registers the `debugpy` adapter and default launch/attach configs for
Python, pointed at mason's own debugpy install
(`mason/packages/debugpy/venv/bin/python`) so it doesn't depend on a system
Python. Lazy-loaded on `ft = "python"`.

**Keymaps (buffer-local, python filetype):**

| Key | Action |
|---|---|
| `<leader>dpm` | Debug the test method closest to the cursor |
| `<leader>dpc` | Debug the test class closest to the cursor |

Test runner is auto-detected (`pytest`/`django`/`unittest`) by probing the
project for `pytest.ini`/`manage.py`/`pyproject.toml`'s `tool.pytest`.

### `leoluz/nvim-dap-go`

Registers the `delve` (`dlv`) adapter and launch/attach/test configs for Go.
`dlv` resolves via mason's `PATH` injection, no explicit path needed.
Lazy-loaded on `ft = "go"`.

**Keymaps (buffer-local, go filetype):**

| Key | Action |
|---|---|
| `<leader>dgt` | Debug the test closest to the cursor (via treesitter) |
| `<leader>dgl` | Re-run the last go test debug session |

## Stage 5c — JS/TS node + browser (Vue/React) adapters

Third DAP PR — the fiddliest of the five languages. One thing to understand
up front: **vscode-js-debug is a single multiplexing server**, not one
binary per runtime. `dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]`
literally reuses the same adapter definition — the `type` field in each
`dap.configurations` entry tells the one server which session kind
(`pwa-node`, `pwa-chrome`, ...) to start. No `nvim-dap-vscode-js` wrapper
plugin needed (it's unmaintained); this is direct `dap.adapters` /
`dap.configurations` config against mason's `js-debug-adapter` package —
the exact same engine VSCode itself uses.

`mason-nvim-dap.nvim`'s `ensure_installed` now includes `"js"` (its own
dap-adapter name for the `js-debug-adapter` mason package).

### Node (`typescript`, `javascript`)

Three configs, picked via `<leader>dc`/`<F5>` (nvim-dap prompts for one if
more than one applies):

| Config | What it does |
|---|---|
| Launch file (node) | Runs the current file with plain `node`. |
| Launch file (tsx runtime, for .ts) | Runs the current file via `npx tsx` so plain `.ts` files execute directly, without a build step. Requires `tsx` as a project dependency (or resolvable via `npx`). |
| Attach to process (--inspect) | Attaches to an already-running `node --inspect` process (prompts to pick one via `dap.utils.pick_process`). |

All three set `skipFiles` to skip stepping into `node_internals`/
`node_modules`.

### Browser (`typescriptreact`, `javascriptreact`, `vue`)

One config — "Launch Chrome against dev server" — prompts for the dev
server URL (default `http://localhost:5173`, Vite's default port; override
for Vue CLI/CRA/Next's `3000`/`8080`) and launches Chrome against it with
`webRoot`/`sourceMaps` set, so breakpoints set in `.vue`/`.tsx` source map
back correctly instead of landing in compiled output.

This is the one place sourcemap/`webRoot` tuning may still be needed per
project (monorepos, custom `outDir`, etc.) — `.vscode/launch.json` support
(already available since Stage 5a) is the escape hatch for anything
project-specific that these defaults don't cover.

**Verification note:** the `node` launch config was verified fully
end-to-end (breakpoint set, session launched, confirmed stopped at the
breakpoint via `dap.listeners`). The Chrome/browser config was verified to
register correctly with the right adapter/type wiring, but a real
Vite-dev-server + Chrome round-trip wasn't exercised headlessly — that
needs a live project and browser to fully confirm.

## Stage 5d — Flutter (closes out Stage 5)

Fourth and final DAP PR — the one explicitly marked must-have. Unlike every
other language in this series, Flutter/Dart debugging isn't wired through
mason at all.

### `nvim-flutter/flutter-tools.nvim`

The maintained org home of akinsho's original plugin. Manages the whole
Flutter dev loop — running, hot reload/restart, device/emulator selection,
DevTools, an outline window — and, with `debugger.enabled = true`, wires
`nvim-dap` automatically via the Dart SDK's own debug adapter. Lazy-loaded
on `ft = "dart"`.

**Important difference from python/go/js:** flutter-tools does **not**
pre-register a static `dap.configurations.dart` at startup the way
`nvim-dap-python`/`nvim-dap-go` do. It builds `dap.adapters.dart` and the
launch config dynamically, inside its own `:FlutterRun`/`:FlutterDebug`
command handlers, using the actual project paths resolved at invocation
time. So Flutter debugging goes through flutter-tools' own commands
(`<leader>Fr` etc.) rather than the generic `<F5>`/`<leader>dc` — this
matches how VSCode's own Flutter extension owns that flow too, rather than
exposing a generic launch-config entry.

flutter-tools also explicitly warns against configuring `dartls` through
`nvim-lspconfig` — it manages the Dart LSP itself. Since `lsp.lua` never
configured `dartls`, there was nothing to remove there; this PR only adds
`flutter.lua`, it doesn't touch `lsp.lua`.

**`vim.ui.select`:** flutter-tools needs a `vim.ui.select` provider for its
device/emulator picker. Rather than adding `dressing.nvim`, `snacks.lua`
now sets `picker.ui_select = true`, so the existing `snacks.nvim` picker
handles it (confirmed via a headless test — `vim.ui.select` only gets
overridden once a UI attaches, via the `UIEnter` autocmd, which is why a
plain headless probe without a simulated UI attach appeared not to work).

**Keymaps:**

| Key | Action |
|---|---|
| `<leader>Fr` | `:FlutterRun` |
| `<leader>FR` | `:FlutterRestart` (hot restart) |
| `<leader>Fh` | `:FlutterReload` (hot reload) |
| `<leader>Fq` | `:FlutterQuit` |
| `<leader>Fd` | `:FlutterDevices` |
| `<leader>Fe` | `:FlutterEmulators` |
| `<leader>Fo` | `:FlutterOutlineToggle` |
| `<leader>FD` | `:FlutterDevTools` |

**Verification note:** this sandbox has no Flutter/Dart SDK installed, so a
real `flutter run` + breakpoint round-trip isn't possible here. What *was*
verified: the plugin loads cleanly on a scratch `.dart`/`pubspec.yaml`
project, all command names above are confirmed against the installed
plugin's own source (not guessed from the README), and calling
`:FlutterRun` without the SDK present fails gracefully (a caught Lua error
from the missing SDK path lookup, not a crash) — nvim stays fully
responsive. The actual debug-session behavior needs a machine with the
Flutter SDK installed to confirm end-to-end.
