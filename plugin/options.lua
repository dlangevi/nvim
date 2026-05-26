local platform = require('platform')

vim.opt.wildmode = "longest,list,full"
vim.opt.wildmenu = true

vim.opt.mouse = ''
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.relativenumber = true
vim.opt.nu = true

-- Clipboard: unnamedplus destroys startup time on Windows/WSL
-- deferred-clipboard.nvim handles clipboard lazily on those platforms
if not platform.is_windows and not platform.is_wsl then
  vim.opt.clipboard = "unnamedplus"
end

vim.opt.list = true

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.laststatus = 3

vim.opt.scrolloff = 10

-- Auto-reload files when changed externally (e.g., by AI CLIs)
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd('checktime')
    end
  end,
})

-- Folds (ufo provider requires large foldlevel)
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
