return {
    "hrsh7th/nvim-cmp",
    enabled = vim.g.plugin_enabled.nvim_cmp,
    event = "InsertEnter",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-vsnip",
        "uga-rosa/cmp-dynamic",
        "notomo/cmp-neosnippet",
        "alpha2phi/cmp-openai-codex",
        "kristijanhusak/vim-dadbod-completion",
    },
    config = function()
        local cmp = require "cmp"
        local luasnip = require "luasnip"
        -- local neogen = require "neogen"
        local icons = require("utils.lspkind").icons

        local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and
                vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
        end

        cmp.setup {
            completion = { completeopt = "menuone,noselect" },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-y>"] = cmp.config.disable,
                ["<C-e>"] = cmp.mapping {
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                },
                ["<CR>"] = cmp.mapping.confirm { select = false },
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expandable() then
                        luasnip.expand()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif luasnip.check_backspace() then
                        fallback()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },
            sources = cmp.config.sources {
                { name = "luasnip",          group_index = 2 },
                {
                    name = "copilot",
                    group_index = 2,
                    trigger_characters = {
                        ".",
                        ":",
                        "(",
                        "'",
                        '"',
                        "[",
                        ",",
                        "#",
                        "*",
                        "@",
                        "|",
                        "=",
                        "-",
                        "{",
                        "/",
                        "\\",
                        "+",
                        "?",
                        " ",
                    },
                },
                { name = "nvim_lsp",         group_index = 2 },
                { name = "dynamic",          group_index = 2 },
                { name = "cmp_tabnine",      group_index = 2 },
                { name = "cmp_openai_codex", group_index = 2 },
                { name = "path",             group_index = 2 },
                { name = "buffer",           group_index = 2 },
                { name = "neosnippet" },
            },
            formatting = {
                fields = { "abbr", "kind", "menu" },
                format = require("utils.lspkind").cmp_format {
                    with_text = true,
                    menu = {
                        nvim_lsp         = "[LSP]",
                        luasnip          = "[LuaSnip]",
                        buffer           = "[Buffer]",
                        nvim_lua         = "[Lua]",
                        ultisnips        = "[UltiSnips]",
                        vsnip            = "[vSnip]",
                        treesitter       = "[treesitter]",
                        look             = "[Look]",
                        copilot          = "[Copilot]",
                        path             = "[Path]",
                        spell            = "[Spell]",
                        calc             = "[Calc]",
                        emoji            = "[Emoji]",
                        neorg            = "[Neorg]",
                        cmp_openai_codex = "[Codex]",
                        cmp_tabnine      = "[TabNine]",
                        dynamic          = "[Dynamic]",
                    },
                },
            },
            confirm_opts = { behavior = cmp.ConfirmBehavior.Replace, select = false },
            window = {
                documentation = cmp.config.window.bordered(),
                completion = cmp.config.window.bordered(),
            },
            experimental = { ghost_text = false },
        }

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = "buffer" } },
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
        })

        -- Auto pairs
        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
    end,
}
