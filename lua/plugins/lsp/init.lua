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
            servers = {
                clangd = {
                    capabilities = clang,
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--pch-storage=memory",
                        "--clang-tidy",
                        "--suggest-missing-includes",
                        "--cross-file-rename",
                        "--completion-style=detailed",
                    },
                    init_options = {
                        clangdFileStatus     = true,
                        usePlaceholders      = true,
                        completeUnimported   = true,
                        semanticHighlighting = true,
                    },
                    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
                    log_level = 2,
                    root_dir = require("lspconfig.util").root_pattern({
                            ".clangd",
                            ".clang-tidy",
                            ".clang-format",
                            "compile_commands.json",
                            "compile_flags.txt",
                            "configure.ac",
                            ".git",
                        }) or vim.loop.cwd(),
                    single_file_support = true,
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = {checkThirdParty = false},
                            completion = {callSnippet = "Replace"},
                            telemetry = {enable = false},
                            hint = {enable = false}
                        }
                    }
                },
                dockerls = {}
            },
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
        opts = {ensure_installed = {"stylua", "clangd"}},
        config = function(_, opts)
            require("mason").setup()
            local mr = require "mason-registry"
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then p:install() end
            end
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
