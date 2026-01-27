return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            auto_install = true,
            indent = { enable = false }, -- rely on LSP
        })
    end,
}
