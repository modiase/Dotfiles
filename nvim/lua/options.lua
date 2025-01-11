---@diagnostic disable-next-line: undefined-global
local vim = vim

vim.opt.autoindent = true
vim.opt.listchars = { extends = '>', precedes = '<' }
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.updatetime = 300
vim.opt.wrap = false

vim.cmd('syntax on')
vim.cmd('colorscheme nord')
