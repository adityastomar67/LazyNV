local M = {}

M.signature_window = function(_, result, ctx, config)
    local bufnr, winner = vim.lsp.handlers.signature_help(_, result, ctx, config)
    local current_cursor_line = vim.api.nvim_win_get_cursor(0)[1]

    if winner then
        if current_cursor_line > 3 then
            vim.api.nvim_win_set_config(winner, {
                anchor = "SW",
                relative = "cursor",
                row = 0,
                col = -1,
            })
        end
    end

    if bufnr and winner then
        return bufnr, winner
    end
end

-- thx to https://github.com/seblj/dotfiles/blob/0542cae6cd9a2a8cbddbb733f4f65155e6d20edf/nvim/lua/config/lspconfig/init.lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local util = require "vim.lsp.util"
local clients = {}

local check_trigger_char = function(line_to_cursor, triggers)
    if not triggers then
        return false
    end

    for _, trigger_char in ipairs(triggers) do
        local current_char = line_to_cursor:sub(#line_to_cursor, #line_to_cursor)
        local prev_char = line_to_cursor:sub(#line_to_cursor - 1, #line_to_cursor - 1)
        if current_char == trigger_char then
            return true
        end
        if current_char == " " and prev_char == trigger_char then
            return true
        end
    end
    return false
end

local open_signature = function()
    local triggered = false

    for _, client in pairs(clients) do
        local triggers = client.server_capabilities.signatureHelpProvider.triggerCharacters

        -- csharp has wrong trigger chars for some odd reason
        if client.name == "csharp" then
            triggers = { "(", "," }
        end

        local pos = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        local line_to_cursor = line:sub(1, pos[2])

        if not triggered then
            triggered = check_trigger_char(line_to_cursor, triggers)
        end
    end

    if triggered then
        local params = util.make_position_params()
        vim.lsp.buf_request(
            0,
            "textDocument/signatureHelp",
            params,
            vim.lsp.with(M.signature_window, {
                border = "single",
                focusable = false,
                -- silent = config.silent,
            })
        )
    end
end

M.setup = function(client)
    -- if config.disabled then
    --     return
    -- end
    table.insert(clients, client)
    local group = augroup("LspSignature", { clear = false })
    vim.api.nvim_clear_autocmds { group = group, pattern = "<buffer>" }

    autocmd("TextChangedI", {
        group = group,
        pattern = "<buffer>",
        callback = function()
            -- Guard against spamming of method not supported after
            -- stopping a language serer with LspStop
            local active_clients = vim.lsp.get_active_clients()
            if #active_clients < 1 then
                return
            end
            open_signature()
        end,
    })
end

-- export on_attach & capabilities for custom lspconfigs
M.on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    if client.server_capabilities.signatureHelpProvider then
        M.setup(client)
    end
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

require("lspconfig").emmet_ls.setup(require("plugins.lsp.servers.emmet-ls"))
require("lspconfig").html.setup({})
require("lspconfig").pyright.setup(require("plugins.lsp.servers.pyright"))
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
require("lspconfig").clangd.setup(require("plugins.lsp.servers.clangd"))
require("lspconfig").bashls.setup(require("plugins.lsp.servers.bashls"))
require("lspconfig").tsserver.setup({
    on_attach = M.on_attach,
    filetypes = { "typescript", "typescriptreact", "typescript.jsx", "javascriptreact" },
    cmd = { "typescript-language-server", "--stdio" }
})
require("lspconfig").tailwindcss.setup({
    on_attach = M.on_attach,
    filetypes = { "typescript", "typescriptreact", "typescript.jsx", "javascriptreact" },
    cmd = { "tailwindcss-language-server", "--stdio" }
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>fd', function()
            vim.diagnostic.open_float { border = "rounded" }
        end, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '[d', function()
            vim.diagnostic.goto_prev()
        end, opts)
        vim.keymap.set('n', ']d', function()
            vim.diagnostic.goto_next()
        end, opts)
        vim.keymap.set('n', '<leader>q', function()
            vim.diagnostic.setloclist()
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>ra', ":IncRename ", opts)
    end
})

return M
