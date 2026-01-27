vim.g.mapleader       = " "

vim.opt.autoread      = true
vim.opt.termguicolors = true
vim.opt.number        = true
vim.opt.showmode      = false
vim.opt.cmdheight     = 1
vim.o.sessionoptions  = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.opt.tabstop       = 4
vim.opt.shiftwidth    = 4
vim.opt.expandtab     = true
vim.opt.softtabstop   = 4

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
})

require("lazy_init")

require("features/lsp")
require("features/diagnostics")
require("features/search")
require("features/file_ops")
require("features/file_watcher")
require("features/local_config")
require("features/jdtls_classfile")

require("servers/efm")
require("servers/luals")
require("servers/jdtls")
require("servers/clangd")
require("servers/rust_analyzer")
