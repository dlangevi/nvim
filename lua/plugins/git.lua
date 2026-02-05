local wk = require('which-key')

return {
  'tpope/vim-fugitive',
  'tommcdo/vim-fugitive-blame-ext',
  'github/copilot.vim',
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
        { "<leader>l", group = "gitlinker" },
        {
          mode = { "n", "v" },
          { "<leader>ll", require("gitlinker").link, desc = "GitLink" },

          {
            "<leader>lL",
            function()
              require("gitlinker").link({ action = require("gitlinker.actions").system })
            end,
            desc = "GitLink!"
          },

          {
            "<leader>lb",
            function()
              require("gitlinker").link({ router_type = "blame" })
            end,
            desc = "GitLink blame"
          },

          {
            "<leader>lB",
            function()
              require("gitlinker").link({
                router_type = "blame",
                action = require("gitlinker.actions").system,
              })
            end,
            desc = "GitLink! blame"
          },

          {
            "<leader>ld",
            function()
              require("gitlinker").link({ router_type = "default_branch" })
            end,
            desc = "GitLink default_branch"
          },

          {
            "<leader>lD",
            function()
              require("gitlinker").link({
                router_type = "default_branch",
                action = require("gitlinker.actions").system,
              })
            end,
            desc = "GitLink! default_branch"
          },

          {
            "<leader>lc",
            function()
              require("gitlinker").link({ router_type = "current_branch" })
            end,
            desc = "GitLink current_branch"
          },

          {
            "<leader>lC",
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
