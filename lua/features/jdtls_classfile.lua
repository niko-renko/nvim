local group = vim.api.nvim_create_augroup("jdtls_classfile", {})

local function open_classfile(uri)
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
    vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
    vim.api.nvim_buf_set_option(bufnr, "swapfile", false)
    vim.api.nvim_buf_set_option(bufnr, "filetype", "java")

    local done = false
    local params = { uri = uri.match }
    local client = vim.tbl_filter(function(c)
        return c.name == "jdtls"
    end, vim.lsp.get_clients())[1]
    local handler = function(err, content)
        assert(not err, vim.inspect(err))
        assert(content, "jdtls client must return result for java/classFileContents")
        local normalized = string.gsub(content, "\r\n", "\n")
        local source_lines = vim.split(normalized, "\n", { plain = true })
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, source_lines)
        vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
        vim.lsp.buf_attach_client(bufnr, client.id)
        done = true
    end

    client:request("java/classFileContents", params, handler, bufnr)
    vim.wait(1000, function() return done == true end)
end

vim.api.nvim_create_autocmd("BufReadCmd", {
    group = group,
    pattern = "jdt://*",
    callback = open_classfile
})
