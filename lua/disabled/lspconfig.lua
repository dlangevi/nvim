-- LSP and syntax highlighing
return {
  'neovim/nvim-lspconfig',
  config = function()
    local keymapper = require('keymapper')
    -- Mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    keymapper.register({
      d = {
        name = "diagnostics",
        -- TODO this one does not work right now
        e = { vim.diagnostic.open_float, "Open floating diagnostics" },
        q = { vim.diagnostic.setloclist, "Open fixlist diagnostics" },
        p = { vim.diagnostic.goto_prev, "Go to next diagnostic" },
        n = { vim.diagnostic.goto_next, "Go to previous diagnostic" }
      }
    }, { prefix = "<leader>" })


    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(arg)
      return function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        keymapper.register({
          g = {
            name = "Go to",
            D = { vim.lsp.buf.declaration, "Declaration" },
            d = { vim.lsp.buf.definition, "Definition" },
            i = { vim.lsp.buf.implementation, "Implementation" },
            r = { vim.lsp.buf.references, "References" }
          },
          K = { vim.lsp.buf.hover, "lsp Hover" },
        }, { buffer = bufnr })

        keymapper.register({
          ["<c-k>"] = { vim.lsp.buf.signature_help, "lsp Signature help" },
        }, { mode = "i", buffer = bufnr })

        -- Might want to put these all in a l = { 'lsp' } level?
        keymapper.register({
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
          ["ca"] = { vim.lsp.buf.code_action, "Code action" },
        }, { prefix = "<leader>", buffer = bufnr })


        keymapper.register({
          ["<c-k>"] = { vim.lsp.buf.signature_help, "lsp Signature help" },
          f = { function()
            if arg.customFormatter then
              arg.customFormatter()
            else
              vim.lsp.buf.format { async = true }
            end
          end, "Format buffer" }
        }, { prefix = "<leader>", buffer = bufnr })
      end
    end

    local lsp_flags = {
      -- This is the default in Nvim 0.7+
      debounce_text_changes = 150,
    }
    -- npm install -g @volar/vue-language-server
    if vim.fn.exepath('vue-language-server') then
      require 'lspconfig'.volar.setup {
        filetypes = { 'typescript',
          'javascript',
          'javascriptreact',
          'typescriptreact',
          'vue',
          'html',
          'json' },
        on_attach = on_attach({
          -- TODO Still not too happy with this
          customFormatter = function()
            vim.cmd "EslintFixAll"
          end
        }),
        flags = lsp_flags,
      }
    end

    -- npm i -g vscode-langservers-extracted
    if vim.fn.exepath('vscode-eslint-language-server') then
      require 'lspconfig'.eslint.setup {
        filetypes = { 'typescript',
          'javascript',
          'vue',
        },
        on_attach = function()
          vim.cmd([[
					au BufWritePre <buffer> silent! EslintFixAll
			]])
        end,
        flags = lsp_flags,
      }
    end

    if vim.fn.exepath('lua-language-server') then
      require 'lspconfig'.lua_ls.setup {
        on_attach = on_attach({}),
        flags = lsp_flags,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      }
    end

    -- go install golang.org/x/tools/gopls@latest
    if vim.fn.exepath('gopls') then
      require 'lspconfig'.gopls.setup {
        on_attach = on_attach({}),
        flags = lsp_flags,
      }
    end

    -- dotnet tool install --global csharp-ls
    if vim.fn.exepath('csharp-ls') then
      require 'lspconfig'.csharp_ls.setup {
        on_attach = on_attach({}),
        flags = lsp_flags,
        filetypes = {
          'cs',
        },
      }
    end
    require 'lspconfig'.omnisharp.setup {
      cmd = { "dotnet", "C:/Users/David.Langevin/scoop/apps/omnisharp/OmniSharp.exe" },
      on_attach = on_attach({}),
      flags = lsp_flags,
      filetypes = {
        'cs',
      },

      -- Enables support for reading code style, naming convention and analyzer
      -- settings from .editorconfig.
      enable_editorconfig_support = true,

      -- If true, MSBuild project system will only load projects for files that
      -- were opened in the editor. This setting is useful for big C# codebases
      -- and allows for faster initialization of code navigation features only
      -- for projects that are relevant to code that is being edited. With this
      -- setting enabled OmniSharp may load fewer projects and may thus display
      -- incomplete reference lists for symbols.
      enable_ms_build_load_projects_on_demand = false,

      -- Enables support for roslyn analyzers, code fixes and rulesets.
      enable_roslyn_analyzers = false,

      -- Specifies whether 'using' directives should be grouped and sorted during
      -- document formatting.
      organize_imports_on_format = false,

      -- Enables support for showing unimported types and unimported extension
      -- methods in completion lists. When committed, the appropriate using
      -- directive will be added at the top of the current file. This option can
      -- have a negative impact on initial completion responsiveness,
      -- particularly for the first few completion sessions after opening a
      -- solution.
      enable_import_completion = false,

      -- Specifies whether to include preview versions of the .NET SDK when
      -- determining which version to use for project loading.
      sdk_include_prereleases = true,

      -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
      -- true
      analyze_open_documents_only = false,
    }

    if vim.fn.exepath('rust-analyzer') then
      require('lspconfig')['rust_analyzer'].setup {
        on_attach = on_attach({}),
        flags = lsp_flags,
        -- Server-specific settings...
        settings = {
          ["rust-analyzer"] = {}
        }
      }
    end

    -- npm i -g vscode-langservers-extracted
    if vim.fn.exepath('vscode-json-language-server') then
      require 'lspconfig'.jsonls.setup {
        on_attach = on_attach({}),
        flags = lsp_flags,
      }
    end

    -- pacman -S haskell-language-server
    if vim.fn.exepath('haskell-language-server-wrapper') then
      require 'lspconfig'.hls.setup {
        filetypes = {
          'haskell',
          'lhaskell',
          'cabal',
        },
        on_attach = on_attach({}),
        flags = lsp_flags,
      }
    end
  end
}
