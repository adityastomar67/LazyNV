return {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    {
        "dstein64/vim-startuptime",
        enabled = vim.g.plugin_enabled.vim_startuptime,
        cmd = "StartupTime",
        config = function()
            vim.g.startuptime_tries = 10
        end,
    },
    {
        "folke/persistence.nvim",
        enabled = vim.g.plugin_enabled.persistence,
        event = "BufReadPre",
        opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
        -- stylua: ignore
        keys = {
            { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>qd", function() require("persistence").stop() end,                desc =
            "Don't Save Current Session" },
        },
    },
    {
        "smjonas/inc-rename.nvim",
        enabled = vim.g.plugin_enabled.inc_rename,
        event = "VeryLazy",
        config = function()
            require("inc_rename").setup()
        end,
    },
    { "nvim-lua/plenary.nvim", lazy = true },
    { "kg8m/vim-simple-align", event = "VeryLazy" },
    { "tpope/vim-repeat",      event = "VeryLazy" },
    {
        "tpope/vim-surround",
        enabled = vim.g.plugin_enabled.vim_surround,
        event = "BufReadPre"
    },
}
