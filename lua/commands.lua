vim.api.nvim_create_user_command("LspInfo", function()
    vim.cmd("checkhealth vim.lsp")
end, {})

vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd("edit " .. vim.lsp.get_log_path())
end, {})
