# Neovim Config Cleanup & Cross-Platform Support Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Centralize platform detection in a single module and fix all existing cross-platform gaps (LSP graceful failure, clipboard, shell, dead code).

**Architecture:** Create `lua/platform.lua` as the single source of truth for OS detection. Replace all inline detection logic. Fix `omnisharp_extended` unsafe requires with pcall. Remove confirmed duplicate keymaps from mason.lua. Clean up options.lua.

**Tech Stack:** Neovim 0.11+, lazy.nvim, which-key.nvim, lua

---

## File Map

| Action | File | What changes |
|--------|------|-------------|
| Create | `lua/platform.lua` | New — centralized OS detection |
| Modify | `lua/plugins/init.lua` | Replace inline NixOS check with `require('platform')` |
| Modify | `lua/lsp/init.lua` | Remove dead `is_nixos` variable and empty if block |
| Modify | `lua/plugins/mason.lua` | Remove duplicate diagnostic + LspAttach keymaps (lines 1–115); add pcall for omnisharp_extended |
| Modify | `lua/lsp/servers.lua` | Wrap `require('omnisharp_extended')` in pcall |
| Modify | `plugin/options.lua` | Platform-aware clipboard; remove duplicate fold settings and dead shell block |
| Modify | `lua/plugins/core.lua` | Platform-aware shell in iron.nvim |

---

### Task 1: Create `lua/platform.lua`

**Files:**
- Create: `lua/platform.lua`

- [ ] **Step 1: Create the platform module**

Write `lua/platform.lua` with this exact content:

```lua
local M = {}

M.is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
M.is_wsl     = vim.env.WSL_DISTRO_NAME ~= nil
M.is_nixos   = vim.fn.executable('nixos-rebuild') == 1 or vim.uv.fs_stat('/etc/nixos') ~= nil
M.is_linux   = vim.fn.has('linux') == 1 and not M.is_wsl and not M.is_nixos

return M
```

- [ ] **Step 2: Verify nvim starts cleanly**

Run: `nvim --headless -c "lua print(require('platform').is_nixos)" +qa 2>&1`

Expected: prints `true` (on NixOS) with no errors.

- [ ] **Step 3: Commit**

```bash
git add lua/platform.lua
git commit -m "feat: add centralized platform detection module"
```

---

### Task 2: Replace inline NixOS detection in `lua/plugins/init.lua`

**Files:**
- Modify: `lua/plugins/init.lua`

Current file content:
```lua
local plugins = {
  { import = 'plugins.core' },
  { import = 'plugins.telescope' },
  { import = 'plugins.treesitter' },
  { import = 'plugins.completion' },
  { import = 'plugins.git' },
  { import = 'plugins.lualine' },
  { import = 'plugins.nvim-tree' },
  { import = 'plugins.agents' },
}

-- Conditional loading of Mason for non-NixOS systems
-- Assuming NixOS has 'nixos-rebuild' in path, or specific file structure
local is_nixos = vim.fn.executable('nixos-rebuild') == 1 or vim.loop.fs_stat('/etc/nixos')

if not is_nixos then
  table.insert(plugins, { import = 'plugins.mason' })
end

return plugins
```

- [ ] **Step 1: Replace the file**

Write `lua/plugins/init.lua` with:

```lua
local platform = require('platform')

local plugins = {
  { import = 'plugins.core' },
  { import = 'plugins.telescope' },
  { import = 'plugins.treesitter' },
  { import = 'plugins.completion' },
  { import = 'plugins.git' },
  { import = 'plugins.lualine' },
  { import = 'plugins.nvim-tree' },
  { import = 'plugins.agents' },
}

if not platform.is_nixos then
  table.insert(plugins, { import = 'plugins.mason' })
end

return plugins
```

- [ ] **Step 2: Verify nvim starts cleanly**

Run: `nvim --headless +qa 2>&1`

Expected: no output (clean exit).

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/init.lua
git commit -m "refactor: use platform module for Mason conditional loading"
```

---

### Task 3: Remove dead code from `lua/lsp/init.lua`

**Files:**
- Modify: `lua/lsp/init.lua`

Current file content:
```lua
local M = {}

function M.setup()
  local diagnostics = require('lsp.diagnostics')
  local keymaps = require('lsp.keymaps')
  local servers = require('lsp.servers')

  -- Setup diagnostics keymaps
  diagnostics.setup_keymaps()

  -- Setup LSP buffer keymaps on attach
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      keymaps.setup_buffer_keymaps(ev, client)
    end
  })

  -- Setup all LSP servers
  -- Only if on NixOS (otherwise Mason handles it)
  local is_nixos = vim.fn.executable('nixos-rebuild') == 1 or vim.loop.fs_stat('/etc/nixos')
  servers.setup_servers()
  if is_nixos then
  end
end

return M
```

- [ ] **Step 1: Rewrite the file removing dead code**

Write `lua/lsp/init.lua` with:

```lua
local M = {}

function M.setup()
  local diagnostics = require('lsp.diagnostics')
  local keymaps = require('lsp.keymaps')
  local servers = require('lsp.servers')

  -- Setup diagnostics keymaps
  diagnostics.setup_keymaps()

  -- Setup LSP buffer keymaps on attach
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      keymaps.setup_buffer_keymaps(ev, client)
    end
  })

  servers.setup_servers()
end

return M
```

- [ ] **Step 2: Verify nvim starts cleanly**

Run: `nvim --headless +qa 2>&1`

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add lua/lsp/init.lua
git commit -m "refactor: remove dead is_nixos code from lsp/init.lua"
```

---

### Task 4: Remove duplicate keymaps from `lua/plugins/mason.lua`

**Files:**
- Modify: `lua/plugins/mason.lua`

The current `lua/plugins/mason.lua` has three sections:
1. Lines 1–66: Diagnostic keymaps — exact duplicate of `lua/lsp/diagnostics.lua`. These are already set up via `lsp/init.lua` calling `diagnostics.setup_keymaps()`.
2. Lines 68–115: LspAttach with buffer keymaps — exact duplicate of `lua/lsp/keymaps.lua`. Already set up via `lsp/init.lua`.
3. Lines 117–233: The actual mason + mason-lspconfig setup — keep this.

- [ ] **Step 1: Rewrite mason.lua keeping only the mason setup**

Write `lua/plugins/mason.lua` with only the mason setup (the `return { ... }` block), removing the duplicate keymap sections at the top:

```lua
return {
  "williamboman/mason.nvim",
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'Hoffs/omnisharp-extended-lsp.nvim',
  },
  config = function()
    local lspconfig = require("lspconfig")
    require("mason").setup()
    local function getInstallPath(package)
      local registry = require("mason-registry")
      return registry.get_package(package):get_install_path()
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }
    require("mason-lspconfig").setup({
      automatic_installation = false,
      handlers = {
        -- handles jsonls rust_analyzer gopls
        function(server_name) -- default handler
          lspconfig[server_name].setup {
            capabilities = capabilities,
          }
        end,

        lua_ls = function()
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT', },
                diagnostics = {
                  globals = { 'vim' },
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
              },
            },
          }
        end,

        volar = function()
          lspconfig.volar.setup {
            filetypes = {
              'typescript',
              'javascript',
              'javascriptreact',
              'typescriptreact',
              'vue',
              'html',
              'json'
            },
          }
        end,

        eslint = function()
          lspconfig.eslint.setup {
            filetypes = {
              'typescript',
              'javascript',
              'vue',
            },
            on_attach = function(_, bufnr)
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
              })
            end,
          }
        end,

        omnisharp = function()
          local ok, omnisharp_extended = pcall(require, 'omnisharp_extended')
          lspconfig.omnisharp.setup {
            capabilities = capabilities,
            handlers = ok and {
              ["textDocument/definition"] = omnisharp_extended.handler,
            } or nil,
            cmd = { "dotnet", getInstallPath("omnisharp") .. "/libexec/OmniSharp.dll",
              "--languageserver" },
            enable_editorconfig_support = true,
            enable_ms_build_load_projects_on_demand = false,
            enable_roslyn_analyzers = true,
            organize_imports_on_format = false,
            enable_import_completion = true,
            sdk_include_prereleases = true,
            analyze_open_documents_only = true,
          }
        end
      }
    })
  end
}
```

- [ ] **Step 2: Verify nvim starts cleanly (on NixOS, mason.lua won't load — that's correct)**

Run: `nvim --headless +qa 2>&1`

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/mason.lua
git commit -m "refactor: remove duplicate keymaps from mason.lua, guard omnisharp_extended with pcall"
```

---

### Task 5: Guard `omnisharp_extended` in `lua/lsp/servers.lua`

**Files:**
- Modify: `lua/lsp/servers.lua`

Current problematic section (lines 56–72):
```lua
vim.lsp.enable('omnisharp')
vim.lsp.config('omnisharp', {
  capabilities = capabilities,
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler,
  },
  ...
```

`require('omnisharp_extended')` is evaluated at load time and errors if the plugin isn't installed.

- [ ] **Step 1: Add pcall guard for omnisharp_extended**

Edit `lua/lsp/servers.lua`. Replace the omnisharp config block (lines 56–72) with:

```lua
  vim.lsp.enable('copilot')

  -- OmniSharp (C#)
  vim.lsp.enable('omnisharp')
  local ok, omnisharp_extended = pcall(require, 'omnisharp_extended')
  vim.lsp.config('omnisharp', {
    capabilities = capabilities,
    handlers = ok and {
      ["textDocument/definition"] = omnisharp_extended.handler,
    } or nil,
    enable_editorconfig_support = true,
    enable_ms_build_load_projects_on_demand = false,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = false,
    enable_import_completion = true,
    sdk_include_prereleases = true,
    analyze_open_documents_only = true,
  })
```

- [ ] **Step 2: Verify nvim starts cleanly**

Run: `nvim --headless +qa 2>&1`

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add lua/lsp/servers.lua
git commit -m "fix: guard omnisharp_extended require with pcall for graceful LSP failure"
```

---

### Task 6: Platform-aware clipboard and clean fold settings in `plugin/options.lua`

**Files:**
- Modify: `plugin/options.lua`

Current issues:
- Line 11: `vim.opt.clipboard = "unnamedplus"` — kills startup on Windows/WSL
- Lines 23–25: `foldmethod`, `foldlevel = 3` — immediately overridden by lines 42–45
- Lines 6: `vim.opt.foldenable = false` — immediately overridden by line 45
- Lines 26–28: `if vim.fn.has("linux") then ... end` — fully commented-out body, dead code

- [ ] **Step 1: Rewrite options.lua**

Write `plugin/options.lua` with:

```lua
local platform = require('platform')

vim.opt.wildmode = "longest,list,full"
vim.opt.wildmenu = true

vim.opt.mouse = ''
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.relativenumber = true
vim.opt.nu = true

-- Clipboard: unnamedplus destroys startup time on Windows/WSL
-- deferred-clipboard.nvim handles clipboard lazily on those platforms
if not platform.is_windows and not platform.is_wsl then
  vim.opt.clipboard = "unnamedplus"
end

vim.opt.list = true

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.laststatus = 3

vim.opt.scrolloff = 10

-- Auto-reload files when changed externally (e.g., by AI CLIs)
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd('checktime')
    end
  end,
})

-- Folds (ufo provider requires large foldlevel)
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
```

- [ ] **Step 2: Verify nvim starts cleanly**

Run: `nvim --headless +qa 2>&1`

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add plugin/options.lua
git commit -m "fix: platform-aware clipboard, remove duplicate fold settings and dead code"
```

---

### Task 7: Platform-aware shell in iron.nvim (`lua/plugins/core.lua`)

**Files:**
- Modify: `lua/plugins/core.lua`

Current hardcoded value at line 173: `command = { "zsh" }`

- [ ] **Step 1: Add platform-aware shell to iron.nvim config**

Edit `lua/plugins/core.lua`. At the top of the iron.nvim `config` function (around line 162), add the platform require, then update the `sh` repl definition:

Change:
```lua
    config = function()
      local iron = require('iron.core');
      iron.setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = {
              command = { "zsh" }
            },
```

To:
```lua
    config = function()
      local platform = require('platform')
      local iron = require('iron.core');
      iron.setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = {
              command = { platform.is_windows and "powershell" or "zsh" }
            },
```

- [ ] **Step 2: Verify nvim starts cleanly**

Run: `nvim --headless +qa 2>&1`

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/core.lua
git commit -m "fix: platform-aware shell for iron.nvim (powershell on Windows, zsh elsewhere)"
```

---

## Done

All tasks complete when:
- `nvim --headless +qa 2>&1` exits with no errors
- `require('platform')` is the single source of platform detection
- No file inlines its own OS detection logic
- `omnisharp_extended` is safely guarded with pcall in both `lsp/servers.lua` and `mason.lua`
- Clipboard is not set on Windows/WSL
- Fold settings are declared once, not twice
