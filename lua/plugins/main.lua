return {
    {
        "navarasu/onedark.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("onedark").setup({ style = "dark" })
            require("onedark").load()
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        version = "*",
        opts = {
            filters = {
                dotfiles = false,
                git_ignored = false
            }
        }
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = false }, -- rely on LSP
            })
        end,
    },

    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        opts = {},
    },

    {
        "kdheepak/lazygit.nvim",
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },

    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {}
    }
}
