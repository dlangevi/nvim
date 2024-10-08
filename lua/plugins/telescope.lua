local function getBuildCommand()
  -- If it is not linux its windows
  if not vim.fn.has("linux") then
    return 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && ' ..
        'cmake --build build --config Release && ' ..
        'cmake --install build --prefix build'
  end
  return 'make'
end

return {
  'nvim-telescope/telescope.nvim',
  -- version = '0.1.3',
  dependencies = {
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = getBuildCommand()
    }
  },
  config = function()
    local present, telescope = pcall(require, "telescope")

    if not present then
      return
    end

    local actions = require('telescope.actions')

    local options = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ['<C-q>'] = actions.smart_add_to_qflist + actions.open_qflist,
          }
        }
      },
      pickers = {
        -- TODO desired behaviour
        -- If only one pane exists, vertical split
        -- If multiple pane exists and one is a help pane, replace its contents
        -- Otherwise replace current pane contents
        help_tags = {
          mappings = {
            i = {
              ["<CR>"] = "select_vertical",
            },
            n = {
              ["<CR>"] = "select_vertical",
            },
          },
        },
      },
    }

    telescope.setup(options)

    local builtin = require('telescope.builtin')

    require('which-key').add({
      { "<leader>s",  group = "telescope" },
      { "<leader>sb", builtin.buffers,     desc = "Find Buffer" },
      { "<leader>sg", builtin.live_grep,   desc = "Grep Project" },
      { "<leader>sh", builtin.help_tags,   desc = "Search help tags" },
      { "<leader>sp", builtin.git_files,   desc = "Find git Files" },
      { "<leader>sr", builtin.resume,      desc = "Resume last Search" },
      { "<leader>sw", builtin.grep_string, desc = "Search for word" },
      {
        "<leader>sf",
        function()
          builtin.find_files({
            hidden = true,
          })
        end,
        desc = "Find File"
      },
    })
  end,
}
