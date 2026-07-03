# Project Map

> **Navigation rule:** When a prompt targets a specific area, go directly to the
> mapped path. Do not scan unrelated directories or read files outside the
> relevant path unless the task explicitly requires cross-cutting changes.

## Tech Stack

- **Editor config:** Neovim (Lua), entry point `init.lua`.
- **Plugin manager:** `folke/lazy.nvim`, bootstrapped and configured in
  `lua/neotredis/lazy.lua`. Plugin specs live under `lua/neotredis/plugins/`
  (one file per plugin, imported wholesale) and `lua/neotredis/plugins/ai/`
  (AI-assistant integrations, imported separately).
- **LSP:** `neovim/nvim-lspconfig` + `mason-org/mason.nvim` /
  `mason-lspconfig.nvim` for server install/management, configured in
  `lua/neotredis/plugins/lsp.lua`.
- **Completion:** `hrsh7th/nvim-cmp`, configured in
  `lua/neotredis/plugins/autocomplete.lua`.
- **Treesitter:** `arborist.nvim` wrapper (not `nvim-treesitter-textobjects`
  directly), configured in `lua/neotredis/plugins/treesitter.lua`.
- **File nav:** `nvim-neo-tree/neo-tree.nvim`, `nvim-telescope/telescope.nvim`,
  netrw, harpoon2.
- **GUI target:** Neovide (see `lua/neotredis/neovide.lua`).
- **Dev workflow:** tracked via GitHub issues/PRs using the `devflow` skill
  (`.claude/skills/devflow/`); no `plans/` directory in this repo — plan
  detail lives in issue bodies instead.

## Project Structure

| Path | Purpose |
|---|---|
| `init.lua` | Entry point; requires `neotredis` modules. |
| `lua/neotredis/lazy.lua` | Bootstraps `lazy.nvim`, imports plugin specs. |
| `lua/neotredis/options.lua` | Core `vim.opt` settings. |
| `lua/neotredis/autocmd.lua` | Autocommands (diagnostics, LSP attach, etc.). |
| `lua/neotredis/remap.lua` | Non-plugin global keymaps. |
| `lua/neotredis/neovide.lua` | Neovide GUI-specific settings. |
| `lua/neotredis/utils.lua` | Shared helper functions. |
| `lua/neotredis/plugins/lsp.lua` | LSP servers, mason, diagnostics config. |
| `lua/neotredis/plugins/lazydev.lua` | `lazydev.nvim` — Lua/nvim-API completion for `lua_ls`. |
| `lua/neotredis/plugins/autocomplete.lua` | `nvim-cmp` sources and mappings. |
| `lua/neotredis/plugins/snacks.lua` | First-class `snacks.nvim` spec (notifier, bigfile, words, quickfile, picker, zen); git keymaps `<leader>gg` lazygit, `<leader>gB` gitbrowse. |
| `lua/neotredis/plugins/treesitter.lua` | Treesitter via `arborist.nvim`. |
| `lua/neotredis/plugins/telescope.lua` | Fuzzy finder + keymaps (`<leader>f*`). |
| `lua/neotredis/plugins/flash.lua` | `flash.nvim` — jump/search motion (`s`/`S`/`r`/`R`). |
| `lua/neotredis/plugins/trouble.lua` | `trouble.nvim` — diagnostics/symbols/references list UI (`<leader>x*`). |
| `lua/neotredis/plugins/todo_comments.lua` | `todo-comments.nvim` — TODO/FIXME highlighting and nav (`]t`/`[t`, `<leader>x*`, `<leader>ft`). |
| `lua/neotredis/plugins/grug-far.lua` | `grug-far.nvim` — project-wide search & replace over ripgrep (`<leader>sr/sw/sf`). |
| `lua/neotredis/plugins/mini-ai.lua` | `mini.ai` — extended `a`/`i` text objects (`daf`, `cia`, brackets, quotes, tags). |
| `lua/neotredis/plugins/file_tree.lua` | neo-tree file explorer. |
| `lua/neotredis/plugins/file_browser.lua` | telescope-file-browser extension. |
| `lua/neotredis/plugins/harpoon.lua` | harpoon2 quick-file navigation. |
| `lua/neotredis/plugins/git.lua`, `gitsigns.lua`, `gitconflict.lua` | Git integration (fugitive `<leader>gs`; gitsigns hunk keymaps `<leader>h*`, `]h`/`[h`; git-conflict). |
| `lua/neotredis/plugins/diffview.lua` | `diffview.nvim` — diffs, file history, merge view (`<leader>gd*`). |
| `lua/neotredis/plugins/gitgraph.lua` | `gitgraph.nvim` — branch/commit line-graph (`<leader>gl`), opens commits in diffview. |
| `lua/neotredis/plugins/dashboard.lua` | Startup dashboard (`dashboard-nvim`; slated for `snacks.dashboard` in Stage 4). |
| `lua/neotredis/plugins/terminal.lua` | Floating terminal (`FTerm.nvim`; slated for `snacks.terminal` in Stage 4). |
| `lua/neotredis/plugins/zenmode.lua` | `true-zen.nvim` (`<leader>zn/zf/zm/za`). |
| `lua/neotredis/plugins/minimap.lua` | `neominimap.nvim`. |
| `lua/neotredis/plugins/colorschema.lua` | Colorscheme selection (ayu active). |
| `lua/neotredis/plugins/ai/` | AI-assistant plugin specs (claudecode.nvim, opencode.nvim). |
| `PLAN.md` | DX-audit tracking doc, untracked in git (see `.gitignore`). |
| `DOCUMENTATION.md` | Plugin reference: what each plugin does and its keymaps. |
| `.github/` | Devflow automation: release drafter, issue auto-close, PR template. |

## Notes

- `lazy-lock.json` and `PLAN.md` are gitignored — don't expect them to show
  up in diffs or PRs.
- Leader-key namespaces in use: `<leader>f*` (telescope), `<leader>g*` (git),
  `<leader>n*` (minimap), `<leader>z*` (zen — true-zen + snacks.zen share the
  namespace without key collisions), `<leader>o*` (opencode), `<leader>c*`
  (claude code), `<leader>a` (harpoon), `<leader>u` (undotree).
