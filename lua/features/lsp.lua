local group = vim.api.nvim_create_augroup("lsp", {})

-- Keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition)

-- Autocmds
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

vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = function()
        for name, _ in pairs(vim.lsp.config._configs) do
            vim.lsp.enable(name)
        end
    end,
})

-- Commands
vim.api.nvim_create_user_command("LspInfo", function()
    vim.cmd("checkhealth vim.lsp")
end, {})

vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd("edit " .. vim.lsp.get_log_path())
end, {})
