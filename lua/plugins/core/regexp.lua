return {
    "bennypowers/nvim-regexplainer",
    enabled = vim.g.plugin_enabled.regexplainer,
    event = "veryLazy",
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'MunifTanjim/nui.nvim',
    },
    opts = {
        mode = 'narrative', -- TODO: 'ascii', 'graphical'
        auto = false,
        filetypes = {
            'html',
            'js',
            'cjs',
            'mjs',
            'ts',
            'jsx',
            'tsx',
            'cjsx',
            'mjsx',
            'lua',
        },
        debug = false,
        display = 'popup',
        mappings = {
            toggle = 'gR',
        },
        narrative = {
            separator = '\n',
        },
    },
    config = function(_, opts)
        require('regexplainer').setup(opts)
    end
}
