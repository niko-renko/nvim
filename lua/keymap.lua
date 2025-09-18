local fzf = require("fzf-lua")
local nvim_tree = require("nvim-tree.api")

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>fg", fzf.live_grep)
vim.keymap.set("n", "<C-n>", nvim_tree.tree.toggle)

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
