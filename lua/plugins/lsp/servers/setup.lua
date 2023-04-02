local M = {}
-- local utils = require "core.utils"

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

    -- utils.load_mappings("lspconfig", { buffer = bufnr })

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

-- TODO: concat on_attch and capabilities on emmet_ls table
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
require("lspconfig").clangd.setup({
    on_attach = M.on_attach,
    capabilities = M.capabilities,
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
})

return M
