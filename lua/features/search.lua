local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>fg", fzf.live_grep)
vim.keymap.set("n", "<leader>ff", fzf.files)
