local checkstyle = {
    rootMarkers = { ".git/" },
    lintCommand = "checkstyle -c config/checkstyle/checkstyle.xml -f plain ${INPUT}",
    lintFormats = {
        "[%tARN] %f:%l:%c: %m [%.%#]",
        "[%tARN] %f:%l: %m [%.%#]"
    },
    lintAfterOpen = true,
    lintStdin = false,
    lintIgnoreExitCode = true
}

vim.lsp.config["efm"] = {
    cmd = { "efm-langserver" },
    filetypes = { "java" },
    root_markers = { ".git" },
    settings = {
        rootMarkers = { ".git/" },
        languages = {
            java = { checkstyle }
        }
    }
}
