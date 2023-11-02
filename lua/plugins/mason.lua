-- TODO this must be able to be made cleaner
local hintsHidden = true
local severity = {
  vim.diagnostic.severity.ERROR,
  vim.diagnostic.severity.WARN,
  vim.diagnostic.severity.INFO,
  vim.diagnostic.severity.HINT,
}
local function toggleSuggestions()
  if hintsHidden then
    severity[vim.diagnostic.severity.INFO] = nil
    severity[vim.diagnostic.severity.HINT] = nil
  else
    severity[vim.diagnostic.severity.INFO] = vim.diagnostic.severity.INFO
    severity[vim.diagnostic.severity.HINT] = vim.diagnostic.severity.HINT
  end

  vim.diagnostic.config({
    underline = {
      severity = severity
    },
    virtual_text = {
      -- language server's name--
      severity = severity
    }
  })
  hintsHidden = not hintsHidden
end

local function goto_next()
  vim.diagnostic.goto_next({
    severity = severity
  })
end

local function goto_prev()
  vim.diagnostic.goto_prev({
    severity = severity
  })
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local whichkey = require('which-key')
whichkey.register({
  d = {
    name = "diagnostics",
    f = { vim.diagnostic.open_float, "Open floating diagnostics" },
    q = { vim.diagnostic.setloclist, "Open fixlist diagnostics" },
    p = { goto_prev, "Go to previous diagnostic" },
    n = { goto_next, "Go to next diagnostic" },
    t = { toggleSuggestions, "Toggle Suggestions" }
  }
}, { prefix = "<leader>" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    whichkey.register({
      g = {
        name = "Go to",
        D = { vim.lsp.buf.declaration, "Declaration" },
        d = { vim.lsp.buf.definition, "Definition" },
        i = { vim.lsp.buf.implementation, "Implementation" },
        r = { vim.lsp.buf.references, "References" }
      },
      K = { vim.lsp.buf.hover, "lsp Hover" },
    }, { buffer = ev.buf })

    whichkey.register({
      ["<c-k>"] = { vim.lsp.buf.signature_help, "lsp Signature help" },
    }, { mode = "i", buffer = ev.buf })

    -- Might want to put these all in a l = { 'lsp' } level?
    whichkey.register({
      w = {
        name = "workspace",
        a = { vim.lsp.buf.add_workspace_folder, "Add workspace" },
        r = { vim.lsp.buf.remove_workspace_folder, "Remove workspace" },
        l = { function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List workspaces" },
      },
      r = { vim.lsp.buf.rename, "Rename variable" },
      D = { vim.lsp.buf.type_definition, "Show type definitions" },
      -- TODO figure out what this is for
      -- ["ca"] = { vim.lsp.buf.code_action, "Code action" },
    }, { prefix = "<leader>", buffer = ev.buf })


    whichkey.register({
      ["<c-k>"] = { vim.lsp.buf.signature_help, "lsp Signature help" },
      f = { function() vim.lsp.buf.format({ async = true }) end, "Format buffer" },
    }, { prefix = "<leader>", buffer = ev.buf })
  end
})

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
    require("mason-lspconfig").setup({
      handlers = {
        lua_ls = function()
          lspconfig.lua_ls.setup {
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT', },
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { 'vim' },
                },
                workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
              },
            },
          }
        end,
        omnisharp = function()
          lspconfig.omnisharp.setup {
            handlers = {
              ["textDocument/definition"] = require('omnisharp_extended').handler,
            },
            cmd = { "dotnet7", getInstallPath("omnisharp") .. "/libexec/OmniSharp.dll",
              "--languageserver" },
            enable_editorconfig_support = true,
            -- set to true if working in a huge codebase maybe
            enable_ms_build_load_projects_on_demand = false,
            enable_roslyn_analyzers = true,
            organize_imports_on_format = false,
            -- doesn't seem to work?
            enable_import_completion = true,
            sdk_include_prereleases = true,
            analyze_open_documents_only = false,
          }
        end
      }
    })
  end
}
