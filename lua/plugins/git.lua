local wk = require('which-key')

return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.g.fugitive_browse_handlers = {
        function(opts)
          local remote = opts.remote or ''
          if string.match(remote, 'github%.docusignhq%.com') then
            local new_url = string.gsub(remote, 'git@github%.docusignhq%.com:', 'https://github.docusignhq.com/')
            new_url = string.gsub(new_url, '%.git$', '')
            -- Append path, line range, etc.
            if opts.path then
              new_url = new_url .. '/blob/' .. opts.commit .. '/' .. opts.path
              if opts.line1 then
                new_url = new_url .. '#L' .. opts.line1
                if opts.line2 and opts.line2 ~= opts.line1 then
                  new_url = new_url .. '-L' .. opts.line2
                end
              end
            else
              new_url = new_url .. '/commit/' .. opts.commit
            end
            
            return new_url
          end
        end
      }
    end
  },
  'tommcdo/vim-fugitive-blame-ext',
  {
    'linrongbin16/gitlinker.nvim',
    lazy = false,
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require("gitlinker").setup({
        opts = {
          mapping = false,
        },
        router = {
          browse = {
            ["^github.docusignhq.com"] = require('gitlinker.routers').github_browse,
          },
          blame = {
            ["^github.docusignhq.com"] = require('gitlinker.routers').github_blame,
          },
        }
      })

      wk.add({
        { "<leader>g", group = "gitlinker" },
        {
          mode = { "n", "v" },
          { "<leader>gl", require("gitlinker").link, desc = "GitLink" },

          {
            "<leader>gL",
            function()
              require("gitlinker").link({ action = require("gitlinker.actions").system })
            end,
            desc = "GitLink!"
          },

          {
            "<leader>gb",
            function()
              require("gitlinker").link({ router_type = "blame" })
            end,
            desc = "GitLink blame"
          },

          {
            "<leader>gB",
            function()
              require("gitlinker").link({
                router_type = "blame",
                action = require("gitlinker.actions").system,
              })
            end,
            desc = "GitLink! blame"
          },

          {
            "<leader>gd",
            function()
              require("gitlinker").link({ router_type = "default_branch" })
            end,
            desc = "GitLink default_branch"
          },

          {
            "<leader>gD",
            function()
              require("gitlinker").link({
                router_type = "default_branch",
                action = require("gitlinker.actions").system,
              })
            end,
            desc = "GitLink! default_branch"
          },

          {
            "<leader>gc",
            function()
              require("gitlinker").link({ router_type = "current_branch" })
            end,
            desc = "GitLink current_branch"
          },

          {
            "<leader>gC",
            function()
              require("gitlinker").link({
                router_type = "current_branch",
                action = require("gitlinker.actions").system,
              })
            end,
            desc = "GitLink! current_branch"
          },
        }
      })
    end,
  }
}
