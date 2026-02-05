local plugins = {
  { import = 'plugins.core' },
  { import = 'plugins.telescope' },
  { import = 'plugins.treesitter' },
  { import = 'plugins.completion' },
  { import = 'plugins.git' },
  { import = 'plugins.lualine' },
  { import = 'plugins.nvim-tree' },
}

-- Conditional loading of Mason for non-NixOS systems
-- Assuming NixOS has 'nixos-rebuild' in path, or specific file structure
local is_nixos = vim.fn.executable('nixos-rebuild') == 1 or vim.loop.fs_stat('/etc/nixos')

if not is_nixos then
  table.insert(plugins, { import = 'plugins.mason' })
end

return plugins
