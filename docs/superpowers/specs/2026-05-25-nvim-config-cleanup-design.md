# Neovim Config Cleanup & Cross-Platform Support

**Date:** 2026-05-25
**Status:** Approved

## Goals

1. LSPs fail gracefully when not installed — no errors, silent no-ops
2. Plugins and settings can be enabled/disabled based on detected OS/environment
3. Platform detection is centralized — no duplicated inline checks

## Non-Goals

- Restructuring the overall plugin organization
- Adding new plugins or features
- Supporting platforms beyond: NixOS, WSL (Ubuntu), Windows native, generic Linux

## Approach

Option C: centralized `platform.lua` module + targeted fixes to existing code. The config is already ~80% correct; this fixes specific gaps rather than restructuring everything.

## Platform Detection Module

New file: `lua/platform.lua`

```lua
local M = {}
M.is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
M.is_wsl     = vim.env.WSL_DISTRO_NAME ~= nil
M.is_nixos   = vim.fn.executable('nixos-rebuild') == 1 or vim.uv.fs_stat('/etc/nixos') ~= nil
M.is_linux   = vim.fn.has('linux') == 1 and not M.is_wsl and not M.is_nixos
return M
```

Any file needing platform info does `local platform = require('platform')`. No file should inline its own OS detection logic.

## Dead Code & Duplication Cleanup

- **`lua/lsp/init.lua` lines 22-25**: `is_nixos` is set but the `if is_nixos then end` block is empty. Delete both lines.
- **`lua/plugins/init.lua` lines 13-14**: Inline NixOS detection replaced by `require('platform').is_nixos`.
- **`plugin/options.lua`**: Remove commented-out Linux shell block; fix duplicate/conflicting fold settings (foldlevel assigned twice, foldenable toggled twice).
- **`lua/plugins/mason.lua`**: Contains LSP attach keymaps and diagnostic keymaps. Read `lua/lsp/diagnostics.lua` and `lua/lsp/keymaps.lua` before touching — only remove confirmed duplicates.

## LSP Graceful Failure

The nvim 0.11 `vim.lsp.enable()` / `vim.lsp.config()` API already silently no-ops when a server binary is not in PATH. No changes needed for most servers.

**Exception**: `require('omnisharp_extended')` in `lua/lsp/servers.lua` is evaluated at config load time. If the plugin is not installed, this throws immediately.

Fix with `pcall`:

```lua
local ok, omnisharp_extended = pcall(require, 'omnisharp_extended')
vim.lsp.config('omnisharp', {
  handlers = ok and {
    ["textDocument/definition"] = omnisharp_extended.handler,
  } or nil,
  -- rest of config unchanged
})
```

Apply the same pattern to the equivalent call in `lua/plugins/mason.lua`.

## Platform-Aware Options & Plugin Config

### Clipboard (`plugin/options.lua`)

Current `vim.opt.clipboard = "unnamedplus"` kills startup time on Windows/WSL (noted in existing comment). `deferred-clipboard.nvim` is already installed — check whether it conflicts before deciding to keep both or rely solely on the conditional.

```lua
local platform = require('platform')
if not platform.is_windows and not platform.is_wsl then
  vim.opt.clipboard = "unnamedplus"
end
```

### Shell in iron.nvim (`lua/plugins/core.lua`)

`zsh` is hardcoded. WSL stays on `zsh` (Linux env). Windows native gets `powershell`.

```lua
local platform = require('platform')
sh = { command = { platform.is_windows and "powershell" or "zsh" } },
```

### Mason (`lua/plugins/init.lua`)

Already conditionally skipped on NixOS. No change to behavior — just replace inline detection with `require('platform').is_nixos`.

## Extension Pattern

For future platform-specific plugins, use lazy.nvim's `cond` field:

```lua
{ 'some/plugin', cond = function() return not require('platform').is_nixos end }
```

`cond = false` skips loading entirely (including setup). `enabled = false` skips installation. Use `cond` for runtime platform decisions.

## Files Changed

| File | Change |
|------|--------|
| `lua/platform.lua` | **New** — centralized detection |
| `lua/plugins/init.lua` | Replace inline NixOS check with `platform` module |
| `lua/lsp/init.lua` | Remove dead `is_nixos` code |
| `lua/lsp/servers.lua` | Wrap `require('omnisharp_extended')` in `pcall` |
| `lua/plugins/mason.lua` | Wrap `require('omnisharp_extended')` in `pcall`; check for keymap duplication |
| `plugin/options.lua` | Platform-aware clipboard; clean up fold settings; remove dead shell block |
| `lua/plugins/core.lua` | Platform-aware shell in iron.nvim |
