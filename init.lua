vim.g.mapleader        = " "

vim.opt.termguicolors  = true
vim.opt.number         = true
vim.opt.showmode       = false
vim.opt.cmdheight      = 1
vim.opt.sessionoptions = ""

vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.softtabstop    = 4

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
})

require("lazy_init")

require("keymap")
require("autocmds")
require("commands")

require("servers/efm")
require("servers/luals")
require("servers/jdtls")
