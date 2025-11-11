return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
        local cmp = require("cmp")
        cmp.setup({
            completion = {
                keyword_length = 2,
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "buffer" },
            }),
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping.confirm({ select = true }),
            }),
            experimental = {
                ghost_text = true
            }
        })
    end,
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
    },
    lazy = true
}
