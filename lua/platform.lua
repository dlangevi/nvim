local M = {}

M.is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
M.is_wsl     = vim.env.WSL_DISTRO_NAME ~= nil
M.is_nixos   = vim.fn.executable('nixos-rebuild') == 1 or vim.uv.fs_stat('/etc/nixos') ~= nil
M.is_linux   = vim.fn.has('linux') == 1 and not M.is_wsl and not M.is_nixos

return M
