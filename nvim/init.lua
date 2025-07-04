---@diagnostic disable-next-line: undefined-global
local vim = vim

local function _pcall(f)
	local ok, error = pcall(f)
	if not ok
	then
		vim.notify(error, vim.log.levels.ERROR)
	end
end




local function setup_bindings()
	require('bindings')
end

local function setup_env()
	require('env')
end

local function setup_functions()
	require('functions')
end

local function setup_options()
	require('options')
end


vim.opt.rtp:prepend(vim.fn.expand('~/Dotfiles/nvim'))
_pcall(setup_env)
_pcall(setup_bindings)
_pcall(setup_functions)


vim.opt.rtp:prepend(vim.fn.expand('~/Dotfiles/nvim'))
_pcall(setup_options)
