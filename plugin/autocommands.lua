vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"Directory.*.props", "Directory.*.targets"},
  command = "set filetype=xml",
})
