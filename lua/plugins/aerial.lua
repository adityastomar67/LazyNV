return {
    "stevearc/aerial.nvim",
    enabled = vim.g.plugin_enabled.aerial,
    keys = {
        {
            '<leader>a',
            '<cmd>AerialToggle!<CR>',
            mode = { "n" },
            desc = "Aerial Toggle",
        }
    },
    opts = {
        on_attach = function(bufnr)
            -- Jump forwards/backwards with '{' and '}'
            vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
            vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
        end
    },
    config = function(_, opts)
        require('aerial').setup(opts)
    end
}
