local home = vim.fn.expand("~")
local caps = {
    classFileContentsSupport = true,
}
local uri_from_jdt = function(uri, callback)
    local client = vim.lsp.get_active_clients({ name = "jdtls" })[1]
    if not client then return end

    client.request(
        "workspace/executeCommand",
        {
            command = "java.contentProvider",
            arguments = { uri }
        },
        function(err, result)
            if err or not result then return end
            -- open a new scratch buffer with the retrieved content
            local bufnr = vim.api.nvim_create_buf(true, false)
            vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
            vim.api.nvim_buf_set_name(bufnr, uri)
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(result, "\n"))
            if callback then callback(bufnr) end
        end,
        0
    )
end
local definition_handler = function(err, result, ctx, config)
    print("here")
    if not result or vim.tbl_isempty(result) then return end
    local location = result[1]
    local uri = location.uri
    if uri:match("^jdt://") then
        uri_from_jdt(uri, function(bufnr)
            vim.api.nvim_set_current_buf(bufnr)
        end)
    else
        vim.lsp.util.jump_to_location(location, "utf-8", true)
    end
end
vim.lsp.config["jdtls"] = {
    cmd = {
        "jdtls",
        "-configuration", home .. "/.cache/jdtls/config",
        "-data", home .. "/.cache/jdtls/workspace"
    },
    filetypes = { "java" },
    root_markers = { ".git", "build.gradle", "build.gradle.kts", "build.xml", "pom.xml", "settings.gradle", "settings.gradle.kts" },
    init_options = {
        extendedClientCapabilities = caps
    },
    handlers = {
        ['textDocument/definition'] = definition_handler
    }
}
vim.lsp.enable("jdtls")
