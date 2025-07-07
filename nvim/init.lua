vim.g.mapleader = ' '

-- Step 1: Bootstrap lazy.nvim
-- This must come first to ensure the runtime path is set up correctly.
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

-- Step 2: Setup lazy.nvim
-- This will load all plugin specifications from the lua/plugins/ directory.
require("lazy").setup("plugins", {
  -- Lazy.nvim options can go here
})

-- Step 3: Load the rest of your configuration
-- These require() calls will now succeed because lazy.nvim has configured the path.
local function _pcall(f_name)
  local ok, _ = pcall(require, f_name)
  if not ok then
    vim.notify("Failed to load " .. f_name, vim.log.levels.ERROR)
  end
end

_pcall('env')
_pcall('bindings')
_pcall('functions')
_pcall('options')