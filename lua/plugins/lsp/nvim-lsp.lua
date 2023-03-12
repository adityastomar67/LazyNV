return {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help"
    },
    config = function ()
        local lsp = require("lspconfig")
        vim.diagnostic.config({ virtual_text = true })

        local diagnostic_signs = {
            { name = "DiagnosticSignError", text = "" },
            { name = "DiagnosticSignWarn",  text = "" },
            { name = "DiagnosticSignHint",  text = "" },
            { name = "DiagnosticSignInfo",  text = "" },
        }

        for _, sign in ipairs(diagnostic_signs) do
            vim.fn.sign_define(sign.name, {
                texthl = sign.name,
                text   = sign.text,
                numhl  = sign.name,
            })
        end

        lsp.html.setup({})
        -- lsp.jdtls.setup({})
        lsp.eslint.setup({})
        lsp.pyright.setup({})
        lsp.tsserver.setup({})
        lsp.tailwindcss.setup({})
        lsp.sqlls.setup({})
        -- lsp.bashls.setup(require("plug.lsp.servers.bashls"))
        lsp.jsonls.setup(require("plugins.lsp.servers.jsonls"))
        lsp.clangd.setup(require("plugins.lsp.servers.clangd"))
        lsp.emmet_ls.setup(require("plugins.lsp.servers.emmet-ls"))
        lsp.lua_ls.setup(require("plugins.lsp.servers.sumneko-lua"))
    end
}
