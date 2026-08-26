-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- lua/config/options.lua
vim.o.shell = "/usr/bin/fish"

-- Disable relative line numbers
vim.opt.relativenumber = false

-- Ensure absolute line numbers are on
vim.opt.number = true
