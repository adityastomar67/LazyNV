return {
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        config = function()
            require('colorizer').setup({
                user_default_options = {
                    tailwind = true,
                },
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        enabled = vim.g.plugin_enabled.nvim_autopairs,
        event = "VeryLazy",
        config = function()
            local npairs = require "nvim-autopairs"
            npairs.setup { check_ts = true }
        end
    },
    -- {
    --     "dstein64/vim-startuptime",
    --     enabled = vim.g.plugin_enabled.vim_startuptime,
    --     cmd = "StartupTime",
    --     config = function()
    --         vim.g.startuptime_tries = 10
    --     end,
    -- },
    -- {
    --     "folke/persistence.nvim",
    --     enabled = vim.g.plugin_enabled.persistence,
    --     event = "BufReadPre",
    --     opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
    --     -- stylua: ignore
    --     keys = {
    --         { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
    --         { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    --         { "<leader>qd", function() require("persistence").stop() end,                desc =
    --         "Don't Save Current Session" },
    --     },
    -- },
    { "nvim-lua/plenary.nvim",     lazy = true },
    { "smjonas/inc-rename.nvim",   enabled = vim.g.plugin_enabled.inc_rename,   config = true },
    -- { "j-hui/fidget.nvim",         enabled = vim.g.plugin_enabled.fidget,       config = true },
    { "kg8m/vim-simple-align",     event = "VeryLazy" },
    { "tpope/vim-repeat",          event = "VeryLazy" },
    -- { "sindrets/winshift.nvim",    event = "BufEnter",                          config = true },
    -- { "s1n7ax/nvim-window-picker", event = "BufEnter",                          config = true },
    -- { "junegunn/limelight.vim",    event = "VeryLazy" },
    { "tpope/vim-surround",        enabled = vim.g.plugin_enabled.vim_surround, event = "BufReadPre" },
}
