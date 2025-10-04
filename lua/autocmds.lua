local local_file = require('local_file')
local group = vim.api.nvim_create_augroup("global", {})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    callback = function()
        vim.lsp.buf.format({ timeout_ms = 2000 })
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil -- Rely on TreeSitter
    end,
})

vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = function()
        local_file.load()
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = function()
        local_file.load()
    end,
})
