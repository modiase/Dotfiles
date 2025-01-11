---@diagnostic disable-next-line: undefined-global
local vim = vim

vim.opt.runtimepath:append(vim.fn.expand('~/Dotfiles/nvim'))

local function _pcall(f)
	local ok, error = pcall(f)
	if not ok
	then
		vim.notify(error, vim.log.levels.ERROR)
	end
end

local function setup_plugins()
	vim.cmd('source ' .. vim.fn.expand('~/Dotfiles/nvim/plugins/index.vim'))
end

local function setup_options()
	require('options')
end

local function setup_bindings()
	require('bindings')
end

local function setup_functions()
	require('functions')
end


_pcall(setup_plugins)
_pcall(setup_options)
_pcall(setup_bindings)
_pcall(setup_functions)
