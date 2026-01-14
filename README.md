<div align="center">
  <img src="assets/logo.svg" width="160" height="160" alt="Neotredis Logo" />
  <h1>Neotredis</h1>
  <p><i>The Sleeper Must Awaken</i></p>
  <p>An Atreides-inspired Neovim configuration built for performance, reliability, and lethal efficiency.</p>
</div>

---

## Overview

**Neotredis** is a sophisticated Neovim distribution that blends the legendary discipline of House Atreides with the modern extensibility of Neovim. It is designed for those who demand a focused development environment without the clutter of traditional "bloatware" distributions.

The name is a portmanteau of **Neovim** and **Atreides**, symbolizing a strategic approach to text editing where every plugin and keybinding serves a specific purpose.

## Structure

The configuration follows a modular architecture to ensure maintainability and ease of customization.

```text
~/.config/nvim/
├── init.lua             # Entry point
├── lua/
│   ├── core/            # Basic options, keymaps, and autocommands
│   ├── plugins/         # Plugin specifications and configurations
│   └── ui/              # Theming and aesthetic refinements
├── assets/              # Logos and documentation media
└── after/               # Filetype-specific overrides
```

## Installation

### Prerequisites

Ensure you have the following installed on your system:

- **Neovim** (v0.9.0 or higher)
- **Git**
- A **Nerd Font** (highly recommended for UI icons)
- **Ripgrep** (for telescope functionality)
- **C Compiler** (gcc/clang for Treesitter parsers)

### Quick Start

1. Back up your existing configuration:

   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone the repository:

   ```bash
   git clone https://github.com/archtreides/neotredis.git ~/.config/nvim
   ```

3. Launch Neovim:
   ```bash
   nvim
   ```
   _Lazy.nvim will automatically handle the installation of all defined packages on the first run._

## Core Packages

Neotredis leverages a curated selection of industry-standard plugins to provide a seamless experience:

- **Package Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) - Predictable and fast plugin management.
- **Tree-sitter**: Superior syntax highlighting and code intelligence.
- **LSP Support**: Integrated via `mason.nvim` and `nvim-lspconfig` for a full IDE-like experience.
- **Telescope**: Extensible fuzzy finder for files, buffers, and symbols.
- **File Explorer**: [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) or similar for intuitive project navigation.
- **Aesthetics**: Custom Atreides-themed color schemes focusing on high contrast and low eye strain.

## Philosophy

Inspired by the Great Houses of the Landsraad, Neotredis adheres to these core tenets:

- **Discipline**: No unnecessary plugins. Each addition must justify its existence.
- **Efficiency**: Optimized startup times and minimal memory footprint.
- **Sovereignty**: Your configuration remains yours. The structure is transparent and easy to fork.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
