vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46_cache/"

vim.g.mapleader = " "

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

require("lazy").setup({
  { import = "plugins" },
}, lazy_config)

require "options"

vim.schedule(function()
  require "autocmds"
  require "mappings"
end)

dofile(vim.g.base46_cache .. "syntax")
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- FIX: https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight
