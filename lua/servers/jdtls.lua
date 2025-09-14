local home = vim.fn.expand("~")
local group = vim.api.nvim_create_augroup("jdtls", {})

local open_classfile = function(uri)
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
    local function handler(err, content)
        assert(not err, vim.inspect(err))
        assert(content, "jdtls client must return result for java/classFileContents")
        local normalized = string.gsub(content, "\r\n", "\n")
        local source_lines = vim.split(normalized, "\n", { plain = true })
        -- vim.bo[bufnr].modifiable = false
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, source_lines)
        vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
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

vim.lsp.config["jdtls"] = {
    cmd = {
        "jdtls",
        "-configuration", home .. "/.cache/jdtls/config",
        "-data", home .. "/.cache/jdtls/workspace"
    },
    filetypes = { "java" },
    root_markers = {
        ".git",
        "build.gradle",
        "build.gradle.kts",
        "build.xml",
        "pom.xml",
        "settings.gradle",
        "settings.gradle.kts"
    },
    init_options = {
        extendedClientCapabilities = {
            classFileContentsSupport = true,
        }
    },
}
vim.lsp.enable("jdtls")
