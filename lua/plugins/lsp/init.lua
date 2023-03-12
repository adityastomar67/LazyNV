return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        config = true
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = true
    },
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help"
        },
        config = true
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = "BufReadPre",
        dependencies = { "mason.nvim" },
        config = function()
            local nls = require "null-ls"
            nls.setup {
                sources = {
                    nls.builtins.formatting.stylua,
                    nls.builtins.diagnostics.ruff
                        .with { extra_args = { "--max-line-length=180" } }
                }
            }
        end
    },
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            {
                "<leader>cd",
                "<cmd>TroubleToggle document_diagnostics<cr>",
                desc = "Document Diagnostics"
            },
            {
                "<leader>cD",
                "<cmd>TroubleToggle workspace_diagnostics<cr>",
                desc = "Workspace Diagnostics"
            }
        }
    },
    { "glepnir/lspsaga.nvim", enabled = vim.g.plugin_enabled.lspsaga , event = "VeryLazy", config = true }
}
