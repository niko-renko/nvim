return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    version = "*",
    opts = {
        hijack_netrw = false,
        filters = {
            dotfiles = false,
            git_ignored = false
        }
    }
}
