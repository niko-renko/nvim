return {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
        pre_restore_cmds = {
            function()
                require("nvim-tree.api").tree.close()
            end
        },
        post_restore_cmds = {
            function()
                require("nvim-tree.api").tree.open()
            end
        },
    },
}
