local lazy_load = function(plugin)
    vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
        group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
        callback = function()
            local file = vim.fn.expand "%"
            local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""

            if condition then
                vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

                -- dont defer for treesitter as it will show slow highlighting
                -- This deferring only happens only when we do "nvim filename"
                if plugin ~= "nvim-treesitter" then
                    vim.schedule(function()
                        require("lazy").load { plugins = plugin }

                        if plugin == "nvim-lspconfig" then
                            vim.cmd "silent! do FileType"
                        end
                    end, 0)
                else
                    require("lazy").load { plugins = plugin }
                end
            end
        end,
    })
end

return {
    {
        "jose-elias-alvarez/typescript.nvim",
        event = "VeryLazy",
        config = function()
            require("typescript").setup({
                disable_commands = false, -- prevent the plugin from creating Vim commands
                debug = false,        -- enable debug logging for commands
                go_to_source_definition = {
                    fallback = true,  -- fall back to standard LSP definition on failure
                },
                server = {            -- pass options to lspconfig's setup method
                    on_attach = require("plugins.lsp.servers.setup").on_attach,
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "jose-elias-alvarez/typescript.nvim",
            "b0o/SchemaStore.nvim",
        },
        init = lazy_load "nvim-lspconfig",
        config = function()
            local lsp = require("lspconfig")
            local icons = require("utils.icons").icons.diagnostics
            vim.diagnostic.config({ virtual_text = true })

            local diagnostic_signs = {
                { name = "DiagnosticSignError", text = icons.Error },
                { name = "DiagnosticSignWarn",  text = icons.Warning },
                { name = "DiagnosticSignHint",  text = icons.Hint },
                { name = "DiagnosticSignInfo",  text = icons.Information },
            }

            for _, sign in ipairs(diagnostic_signs) do
                vim.fn.sign_define(sign.name, {
                    texthl = sign.name,
                    text   = sign.text,
                    numhl  = sign.name,
                })
            end
            require "plugins.lsp.servers.setup"
        end,
    } }
