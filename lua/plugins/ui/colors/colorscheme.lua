return {
    {
        "folke/tokyonight.nvim",
        enabled = vim.g.plugin_enabled.colorscheme.tokyonight,
        lazy = false,
        priority = 1000,
        config = function()
            local tokyonight = require "tokyonight"
            tokyonight.setup { style = "storm" }
            tokyonight.load()
        end,
    },
    {
        "catppuccin/nvim",
        enabled = vim.g.plugin_enabled.colorscheme.catppuccin,
        lazy = false,
        name = "catppuccin",
    },
    {
        "ellisonleao/gruvbox.nvim",
        enabled = vim.g.plugin_enabled.colorscheme.gruvbox,
        lazy = false,
        config = function()
            require("gruvbox").setup()
        end,
    },
    {
        "sainnhe/sonokai",
        enabled = vim.g.plugin_enabled.colorscheme.sonokai,
        lazy = false,
        opts = {
            sonokai_style = 'default', --'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'
        },
        config = true,
    },
    {
        "sainnhe/everforest",
        enabled = vim.g.plugin_enabled.colorscheme.everforest,
        lazy = false,
        config = function()
            require("everforest").setup()
        end,
    },
    {
        "sainnhe/edge",
        enabled = vim.g.plugin_enabled.colorscheme.edge,
        lazy = false,
        config = function()
            require("edge").setup()
        end,
    },
    { 
        "Alexis12119/nightly.nvim",
        config = function()
            require("nightly").setup({
                transparent = true,
                highlights = {
                    -- add or override highlights
                    -- Normal = { bg = "#000000" }
                },
            })
        end,    
    },
    {
        "navarasu/onedark.nvim",
        enabled = vim.g.plugin_enabled.colorscheme.onedark,
        lazy = false,
        opts = {
            style = 'darker',
            transparent = true
        },
        config = function(_, opts)
            require("onedark").setup(opts)
            require("onedark").load()
        end,
    },
}
