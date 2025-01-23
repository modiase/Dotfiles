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

vim.api.nvim_set_hl(0, 'DiffAdd', {
	fg = '#ffffff',
	bg = '#103510',
	blend = 80,
})

vim.api.nvim_set_hl(0, 'DiffChange', {
	fg = '#ffffff',
	bg = '#105080',
	blend = 80,
})

vim.api.nvim_set_hl(0, 'DiffDelete', {
	fg = '#ffffff',
	bg = '#401010',
	blend = 80,
})
