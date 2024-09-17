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
wk.add({

  { "<leader>d",  group = "diagnostics" },
  { "<leader>dd", disableSuggestions,        desc = "Disable Suggestions" },
  { "<leader>de", enableSuggestions,         desc = "Enable Suggestions" },
  { "<leader>df", vim.diagnostic.open_float, desc = "Open floating diagnostics" },
  { "<leader>dn", goto_next,                 desc = "Go to next diagnostic" },
  { "<leader>dp", goto_prev,                 desc = "Go to previous diagnostic" },
  { "<leader>dq", vim.diagnostic.setloclist, desc = "Open fixlist diagnostics" },
  { "<leader>dt", toggleSuggestions,         desc = "Toggle Suggestions" },
})

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
      if client ~= nil and client.name == "volar" then
        vim.cmd "EslintFixAll"
      else
        vim.lsp.buf.format({ async = true })
      end
    end

    wk.add({
      {
        buffer = ev.buf,
        { "K",             vim.lsp.buf.hover,           desc = "lsp Hover" },

        { "g",             group = "Go to" },
        { "gD",            vim.lsp.buf.declaration,     desc = "Declaration" },
        { "gT",            vim.lsp.buf.type_definition, desc = "Show type definitions" },
        { "gd",            vim.lsp.buf.definition,      desc = "Definition" },
        { "gi",            vim.lsp.buf.implementation,  desc = "Implementation" },
        { "gr",            vim.lsp.buf.references,      desc = "References" },

        { "<leader>r",     vim.lsp.buf.rename,          desc = "Rename variable" },
        { "<leader><c-k>", vim.lsp.buf.signature_help,  desc = "lsp Signature help" },
        { "<leader>f",     formatBuffer,                desc = "Format buffer" },

        {
          mode = "i",
          { "c-k", vim.lsp.buf.signature_help, desc = "lsp Signature help" },
        },

        {
          mode = { "n", "v" },
          { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
        }
      }
    })

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
    -- lspconfig.setup({
    --   opts = {
    --     autoformat = false,
    --   },
    -- })
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
            capabilities = capabilities,
            opts = {
              -- autoformat = false,
            },
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
            analyze_open_documents_only = true,
          }
        end
      }
    })
  end
}
