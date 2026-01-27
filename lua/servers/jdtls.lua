local home = vim.fn.expand("~")

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
