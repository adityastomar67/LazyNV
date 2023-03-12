local clang = vim.lsp.protocol.make_client_capabilities()
clang.offsetEncoding = { "utf-8" }

return {
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            {"j-hui/fidget.nvim", config = true},
            {"smjonas/inc-rename.nvim", config = true},
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help"
        },
        config = function(plugin, _)
            require("plugins.lsp.servers").setup(plugin, {
            setup = {
                lua_ls = function(_, _)
                    local lsp_utils = require "plugins.lsp.utils"
                    lsp_utils.on_attach(function(client, buffer)
                        -- stylua: ignore
                        if client.name == "lua_ls" then
                            vim.keymap.set("n", "<leader>dX", function()
                                require("osv").run_this()
                            end, {buffer = buffer, desc = "OSV Run"})
                            vim.keymap.set("n", "<leader>dL", function()
                                require("osv").launch({port = 8086})
                            end, {buffer = buffer, desc = "OSV Launch"})
                        end
                    end)
                end
            }
        })
        end
    }, {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = {{"<leader>cm", "<cmd>Mason<cr>", desc = "Mason"}},
        config = function()
            require("mason").setup()
        end
    }, {
        "jose-elias-alvarez/null-ls.nvim",
        event = "BufReadPre",
        dependencies = {"mason.nvim"},
        config = function()
            local nls = require "null-ls"
            nls.setup {
                sources = {
                    nls.builtins.formatting.stylua,
                    nls.builtins.diagnostics.ruff
                        .with {extra_args = {"--max-line-length=180"}}
                }
            }
        end
    }, {
        "folke/trouble.nvim",
        cmd = {"TroubleToggle", "Trouble"},
        opts = {use_diagnostic_signs = true},
        keys = {
            {
                "<leader>cd",
                "<cmd>TroubleToggle document_diagnostics<cr>",
                desc = "Document Diagnostics"
            }, {
                "<leader>cD",
                "<cmd>TroubleToggle workspace_diagnostics<cr>",
                desc = "Workspace Diagnostics"
            }
        }
    },
    {"glepnir/lspsaga.nvim", enabled = false, event = "VeryLazy", config = true}
}
