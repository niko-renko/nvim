local local_file = require("local_file")
local group = vim.api.nvim_create_augroup("global", {})

local watchers = {}

local function watch_file(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    if filepath == "" then return end

    if watchers[bufnr] then
        watchers[bufnr]:stop()
    end

    local w = vim.uv.new_fs_poll()
    w:start(filepath, 1000, vim.schedule_wrap(function(err)
        if err or not vim.api.nvim_buf_is_valid(bufnr) then return end
        vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("checktime")
        end)
    end))
    watchers[bufnr] = w
end

vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function(args)
        watch_file(args.buf)
    end,
})

vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(args)
        if watchers[args.buf] then
            watchers[args.buf]:stop()
            watchers[args.buf] = nil
        end
    end,
})

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
        for name, _ in pairs(vim.lsp.config._configs) do
            vim.lsp.enable(name)
        end
    end,
})
