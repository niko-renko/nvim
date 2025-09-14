local home = vim.fn.expand("~")
local caps = {
    actionableRuntimeNotificationSupport = true,
    advancedExtractRefactoringSupport = true,
    advancedGenerateAccessorsSupport = true,
    advancedIntroduceParameterRefactoringSupport = true,
    advancedOrganizeImportsSupport = true,
    advancedUpgradeGradleSupport = true,
    classFileContentsSupport = true,
    clientDocumentSymbolProvider = true,
    clientHoverProvider = false,
    executeClientCommandSupport = true,
    extractInterfaceSupport = true,
    generateConstructorsPromptSupport = true,
    generateDelegateMethodsPromptSupport = true,
    generateToStringPromptSupport = true,
    gradleChecksumWrapperPromptSupport = true,
    hashCodeEqualsPromptSupport = true,
    inferSelectionSupport = { "extractConstant", "extractField", "extractInterface", "extractMethod", "extractVariableAllOccurrence", "extractVariable" },
    moveRefactoringSupport = true,
    onCompletionItemSelectedCommand = "editor.action.triggerParameterHints",
    overrideMethodsPromptSupport = true
}
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
    }
}
vim.lsp.enable("jdtls")
