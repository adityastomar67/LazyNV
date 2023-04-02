local M = {}
-- local utils = require "core.utils"

-- export on_attach & capabilities for custom lspconfigs
M.on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- utils.load_mappings("lspconfig", { buffer = bufnr })

    -- if client.server_capabilities.signatureHelpProvider then
    --     require("nvchad_ui.signature").setup(client)
    -- end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

-- lsp.html.setup({})
--         -- lsp.jdtls.setup({})
--         lsp.eslint.setup({})
--         lsp.pyright.setup({})
--         lsp.tsserver.setup({})
--         lsp.tailwindcss.setup({})
--         lsp.sqlls.setup({})
--         -- lsp.bashls.setup(require("plug.lsp.servers.bashls"))
--         lsp.jsonls.setup(require("plugins.lsp.servers.jsonls"))
--         lsp.clangd.setup(require("plugins.lsp.servers.clangd"))
--         lsp.emmet_ls.setup(require("plugins.lsp.servers.emmet-ls"))
--         lsp.lua_ls.setup(require("plugins.lsp.servers.sumneko-lua"))

require("lspconfig").emmet_ls.setup(require("plugins.lsp.servers.emmet-ls"))
require("lspconfig").lua_ls.setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities,

    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
}

return M
