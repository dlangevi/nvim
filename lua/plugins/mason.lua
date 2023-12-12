-- TODO this must be able to be made cleaner
local hintsHidden = true
local severity = {
  min = vim.diagnostic.severity.WARN
}

local function updateDiagnostics()
  vim.diagnostic.config({
    underline = {
      severity = severity
    },
    virtual_text = {
      -- language server's name--
      severity = severity
    }
  })
  vim.print(severity)
end
updateDiagnostics()

local function disableSuggestions()
  severity.min = vim.diagnostic.severity.WARN;
  updateDiagnostics()
  hintsHidden = true
end

local function enableSuggestions()
  severity.min = vim.diagnostic.severity.HINT;
  updateDiagnostics()
  hintsHidden = false
end

local function toggleSuggestions()
  if hintsHidden then
    enableSuggestions()
  else
    disableSuggestions()
  end
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
local wk = require('which-key')
wk.register({
  d = {
    name = "diagnostics",
    f = { vim.diagnostic.open_float, "Open floating diagnostics" },
    q = { vim.diagnostic.setloclist, "Open fixlist diagnostics" },
    p = { goto_prev, "Go to previous diagnostic" },
    n = { goto_next, "Go to next diagnostic" },
    t = { toggleSuggestions, "Toggle Suggestions" },
    d = { disableSuggestions, "Disable Suggestions" },
    e = { enableSuggestions, "Enable Suggestions" }
  }
}, { prefix = "<leader>" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- The lspclient that has just attached
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local function formatBuffer()
      -- volar's format doesnt respect eslint rules
      -- until I find a way to do that, this ugly hack
      -- will work
      if client.name == "volar" then
        vim.cmd "EslintFixAll"
      else
        vim.lsp.buf.format({ async = true })
      end
    end

    wk.register({
      g = {
        name = "Go to",
        D = { vim.lsp.buf.declaration, "Declaration" },
        d = { vim.lsp.buf.definition, "Definition" },
        i = { vim.lsp.buf.implementation, "Implementation" },
        r = { vim.lsp.buf.references, "References" }
      },
      K = { vim.lsp.buf.hover, "lsp Hover" },
    }, { buffer = ev.buf })

    wk.register({
      ["<c-k>"] = { vim.lsp.buf.signature_help, "lsp Signature help" },
    }, { mode = "i", buffer = ev.buf })

    -- Might want to put these all in a l = { 'lsp' } level?
    wk.register({
      r = { vim.lsp.buf.rename, "Rename variable" },
      D = { vim.lsp.buf.type_definition, "Show type definitions" },
      -- TODO figure out what this is for
      ["ca"] = { vim.lsp.buf.code_action, "Code action" },
      ["<c-k>"] = { vim.lsp.buf.signature_help, "lsp Signature help" },
      f = { formatBuffer, "Format buffer" },
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
        -- handles jsonls rust_analyzer gopls
        function(server_name) -- default handler
          lspconfig[server_name].setup {}
        end,

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
            --[[ on_attach = on_attach({
              -- TODO Still not too happy with this
              customFormatter = function()
                vim.cmd "EslintFixAll"
              end
            }), ]]
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
          lspconfig.omnisharp.setup {
            handlers = {
              ["textDocument/definition"] = require('omnisharp_extended').handler,
            },
            cmd = { "dotnet", getInstallPath("omnisharp") .. "/libexec/OmniSharp.dll",
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
