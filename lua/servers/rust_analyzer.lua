vim.lsp.config["rust_analyzer"] = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = {
        "Cargo.toml",
        "Cargo.lock",
        "rust-project.json",
        ".git",
    },
}
