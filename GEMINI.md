# Neovim Configuration (`.config/nvim`)

This directory contains the user's configuration for Neovim, written in Lua. It uses `lazy.nvim` as a plugin manager and follows a modular structure.

## Project Overview

*   **Type:** Neovim Configuration
*   **Language:** Lua
*   **Plugin Manager:** [`lazy.nvim`](https://github.com/folke/lazy.nvim)
*   **Colorscheme:** `sonokai`
*   **Key Features:**
    *   LSP support (Lua, C#, Rust, Go, etc.) via `nvim-lspconfig`.
    *   REPL integration via `iron.nvim`.
    *   Keybinding management via `which-key.nvim`.
    *   Tmux navigation integration via `smart-splits.nvim`.
    *   Custom AI CLI integration (`GeminiHere`, `CopilotHere`).

## Directory Structure

*   **`init.lua`**: The entry point. Bootstraps `lazy.nvim` and loads the `plugins` module.
*   **`lua/`**: Contains Lua modules.
    *   **`plugins/`**: Plugin configurations.
        *   `init.lua`: The main plugin specification file loaded by `lazy.nvim`.
        *   *Note:* Other files in this directory (e.g., `completion.lua`, `treesitter.lua`) appear to be currently **inactive** as they are not explicitly imported in `init.lua` or `plugins/init.lua`.
    *   **`lsp/`**: Language Server Protocol (LSP) configuration.
        *   `init.lua`: Bootstraps the LSP setup.
        *   `servers.lua`: Defines which servers to enable and their settings.
        *   `keymaps.lua`, `diagnostics.lua`: Helper modules for LSP-related bindings and UI.
*   **`plugin/`**: Scripts automatically executed by Neovim on startup.
    *   `options.lua`: Sets global editor options (spaces, line numbers, clipboard, etc.).
    *   `autocommands.lua`: Defines auto-commands (e.g., filetype detection).
    *   `autorun.lua`: Contains custom commands like `AttachRunner` for live execution of TS files.
    *   `clis.lua`: (Likely) contains definitions for CLI tools.
*   **`lazy-lock.json`**: Lockfile for `lazy.nvim` to ensure reproducible plugin versions.

## Building and Running

Since this is a configuration for an editor:

1.  **Install Neovim:** Ensure Neovim (v0.8+) is installed.
2.  **Install Dependencies:**
    *   `git` (for lazy.nvim)
    *   `ripgrep` (recommended for Telescope/searching)
    *   **LSP Servers:** This config assumes some servers are available in the path (especially on NixOS), or uses `mason` (conditionally) to install them.
3.  **Run:** Start Neovim by running `nvim` in your terminal.
    *   On first run, `lazy.nvim` will automatically bootstrap and install defined plugins.
    *   Run `:checkhealth` to verify the installation and look for issues.

## Development Conventions

*   **Plugin Definition:** New plugins should be added to `lua/plugins/init.lua`.
*   **LSP Configuration:**
    *   To enable a new language server, edit `lua/lsp/servers.lua`.
    *   Simple servers can be added to the `simple_servers` list.
    *   Complex configurations should be added using `vim.lsp.config`.
*   **Keybindings:**
    *   Global keybindings are often managed in `lua/plugins/init.lua` within the `which-key` configuration.
    *   LSP-specific keybindings are in `lua/lsp/keymaps.lua`.
*   **Formatting:** The project uses 2 spaces for indentation (`expandtab`, `shiftwidth=2`).

## Known Issues / TODOs

*   **Orphaned Config Files:** Several files in `lua/plugins/` (like `treesitter.lua`, `completion.lua`) seem to be unused. Verify if these should be integrated into `lua/plugins/init.lua` or deleted.
*   **NixOS Compatibility:** There are comments indicating specific handling for NixOS (e.g., disabling Mason, assuming servers in PATH).
