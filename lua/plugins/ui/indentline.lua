return {
    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = plugin_enabled.indent_blankline,
        event = "BufReadPre",
        config = true
    },
    {
        "echasnovski/mini.indentscope",
        enabled = plugin_enabled.indentscope,
        version = false, -- wait till new 0.7.0 release to put it back on semver
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            symbol = "│",
            options = { try_as_border = true }
        },
        config = function(_, opts)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason"
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end
            })
            require("mini.indentscope").setup(opts)
        end
    }
}
