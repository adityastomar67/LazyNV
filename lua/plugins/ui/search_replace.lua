return {
    {
        "windwp/nvim-spectre",
        enabled = plugin_enabled.nvim_spectre,
        event = "VeryLazy",
        keys = {
            {
                "<leader>sr",
                function() require("spectre").open() end,
                desc = "Replace in Files (Spectre)"
            }
        }
    },
    {
        "kevinhwang91/nvim-hlslens",
        enabled = plugin_enabled.hlslens,
        event = "VeryLazy",
        keys = {
            {
                "n",
                [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]]
            },
            {
                "N",
                [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]]
            },
            { "*",  [[*<Cmd>lua require('hlslens').start()<CR>]] },
            { "#",  [[#<Cmd>lua require('hlslens').start()<CR>]] },
            { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
            { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] }
        },
        config = function() require("hlslens").setup() end
    }
}
