vim.lsp.config["roslyn_ls"] = {
    cmd = { "roslyn", "--stdio", "--logLevel=Warning", "--extensionLogDirectory=" .. vim.fn.stdpath("log") },
    filetypes = { "cs" },
    root_markers = {
        "*.sln",
        "*.csproj",
        ".git",
    },
    on_init = function(client)
        local root = client.root_dir or vim.fn.getcwd()
        local sln = vim.fn.glob(root .. "/*.sln")
        if sln ~= "" then
            local sln_file = vim.split(sln, "\n")[1]
            client:notify("solution/open", { solution = vim.uri_from_fname(sln_file) })
        end
    end,
}
