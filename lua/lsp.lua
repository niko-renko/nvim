local home = vim.fn.expand("~")

vim.lsp.set_log_level("debug")

vim.lsp.config["luals"] = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    init_options = {},
}
vim.lsp.enable("luals")

vim.lsp.config["jdtls"] = {
    cmd = {
        "jdtls",
        "-configuration", home .. "/.cache/jdtls/config",
        "-data", home .. "/.cache/jdtls/workspace"
    },
    filetypes = { "java" },
    root_markers = { ".git", "build.gradle", "build.gradle.kts", "build.xml", "pom.xml", "settings.gradle", "settings.gradle.kts" },
    init_options = {},
}
vim.lsp.enable("jdtls")
