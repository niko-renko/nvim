return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    version = "*",
    opts = {
        filters = {
            dotfiles = false,
            git_ignored = false
        }
    }
}
