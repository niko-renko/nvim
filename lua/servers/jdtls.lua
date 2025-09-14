local home = vim.fn.expand("~")
local group = vim.api.nvim_create_augroup("jdtls", {})

local open_classfile = function(fname)
    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].modifiable = true
    vim.bo[buf].swapfile = false
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].filetype = 'java'
    local client = vim.tbl_filter(function(c)
        return c.name == 'jdtls'
    end, vim.lsp.get_clients())[1]

    local content
    local function handler(err, result)
        assert(not err, vim.inspect(err))
        assert(result, "jdtls client must return result for java/classFileContents")
        content = result
        local normalized = string.gsub(result, '\r\n', '\n')
        local source_lines = vim.split(normalized, "\n", { plain = true })
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, source_lines)
        vim.bo[buf].modifiable = false
    end
    local params = {
        uri = fname
    }
    client:request("java/classFileContents", params, handler, buf)
    vim.wait(1000, function() return content ~= nil end)
end


vim.api.nvim_create_autocmd("BufReadCmd", {
    group = group,
    pattern = "jdt://*",
    callback = function(args)
        open_classfile(args.match)
    end
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
