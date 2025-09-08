local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep" })
