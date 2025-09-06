vim.g.mapleader = " "

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format({ timeout_ms = 2000 })
	end,
})

require("config.lazy")
