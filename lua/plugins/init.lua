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
