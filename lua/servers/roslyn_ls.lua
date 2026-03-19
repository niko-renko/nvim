vim.lsp.config["roslyn_ls"] = {
    cmd = { "roslyn", "--stdio" },
    filetypes = { "cs" },
    root_dir = function(bufnr, on_dir)
        local sln = vim.fs.find(function(name)
            return name:match("%.sln$")
        end, { upward = true, path = vim.api.nvim_buf_get_name(bufnr) })[1]

        if sln then
            on_dir(vim.fs.dirname(sln))
        end
    end,
    capabilities = {
        textDocument = {
            diagnostic = {
                dynamicRegistration = true,
            },
        },
    },
    on_init = {
        function(client)
            if not client.config.root_dir then
                return
            end

            local sln = vim.fs.find(function(name)
                return name:match("%.sln$")
            end, { upward = true, path = client.config.root_dir, type = "file" })[1]

            if not sln then
                return
            end

            client:notify("solution/open", { solution = vim.uri_from_fname(sln) })
            vim.notify("Roslyn target: " .. vim.fn.fnamemodify(sln, ":t"))
        end,
    },
    handlers = {
        ["workspace/projectInitializationComplete"] = function(_, _, ctx)
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            if client then
                vim.notify("Roslyn ready", vim.log.levels.INFO)
            end
        end,
    },
}
