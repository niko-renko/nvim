vim.lsp.config["clangd"] = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "cuda" },
    root_markers = {
        "compile_commands.json",
        "compile_flags.txt",
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "CMakeLists.txt",
        "Makefile",
        ".git",
    },
}
