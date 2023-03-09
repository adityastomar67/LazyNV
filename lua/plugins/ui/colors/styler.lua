return {
    "folke/styler.nvim",
    enabled = plugin_enabled.styler,
    event = "VeryLazy",
    config = function()
        require("styler").setup {
            themes = {
                markdown = { colorscheme = "gruvbox" },
                help     = { colorscheme = "gruvbox" },
                lazy     = { colorscheme = "tokyonight" },
            },
        }
    end,
}
