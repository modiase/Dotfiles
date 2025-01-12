---@diagnostic disable-next-line: undefined-global
local vim = vim

local function _pcall(f)
	local ok, error = pcall(f)
	if not ok
	then
		vim.notify(error, vim.log.levels.ERROR)
	end
end

local function setup_plugins()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
	require('lazy').setup('plugins')
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


vim.opt.rtp:prepend(vim.fn.expand('~/Dotfiles/nvim'))
_pcall(setup_bindings)
_pcall(setup_functions)
_pcall(setup_plugins)

vim.opt.rtp:prepend(vim.fn.expand('~/Dotfiles/nvim'))
_pcall(setup_options)
