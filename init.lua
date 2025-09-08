vim.g.mapleader = " "

vim.opt.termguicolors = true
vim.opt.number = true

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
})

require("keymap")
require("autocmds")
require("config.lazy")
