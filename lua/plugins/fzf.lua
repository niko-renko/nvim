return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "<leader>ff", function() require("fzf-lua").files() end,             desc = "Find files" },
        { "<leader>fg", function() require("fzf-lua").live_grep() end,         desc = "Live grep" },
        { "grr",        function() require("fzf-lua").lsp_references() end,    desc = "Find references" },
        { "gd",         function() require("fzf-lua").lsp_definitions() end,   desc = "Go to definition" },
    },
    opts = {},
}
