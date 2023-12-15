vim.opt.wildmode = "longest,list,full"
vim.opt.wildmenu = true

vim.opt.mouse = ''
vim.opt.swapfile = false
vim.opt.foldenable = false
vim.opt.undofile = false
vim.opt.relativenumber = true
vim.opt.nu = true
-- This absolutly destroys startup time on windows + wsl
vim.opt.clipboard = "unnamedplus"
vim.opt.list = true

vim.opt.autoindent = true
vim.opt.expandtab = true
-- Why is this a global vs opt?
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.laststatus = 3

-- Folds
vim.opt.foldmethod = "syntax"
vim.opt.foldlevel = 3
vim.opt.shell = "/usr/bin/bash"
-- set verbose=1
vim.opt.scrolloff = 10

vim.opt.foldcolumn = '1' -- '0' is not bad
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
