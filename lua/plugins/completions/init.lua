return {
    "hrsh7th/nvim-cmp",
    enabled = vim.g.plugin_enabled.nvim_cmp,
    event = "InsertEnter",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-vsnip",
        "notomo/cmp-neosnippet",
        "alpha2phi/cmp-openai-codex",
        "kristijanhusak/vim-dadbod-completion",
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                "adityastomar67/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
            keys = {
                {
                    "<a-k>",
                    function()
                        if require("luasnip").jumpable(-1) then
                            require("luasnip").jump(-1)
                        end
                    end,
                    mode = { "i", "s" },
                    silent = true
                },
                {
                    "<a-j>",
                    function()
                        if require("luasnip").jumpable(1) then
                            require("luasnip").jump(1)
                        end
                    end,
                    mode = { "i", "s" },
                    silent = true
                },
                {
                    "<a-l>",
                    function()
                        if require("luasnip").choice_active() then
                            require("luasnip").change_choice(1)
                        end
                    end,
                    mode = { "i", "s" }
                },
                {
                    "<a-h>",
                    function()
                        if require("luasnip").choice_active() then
                            require("luasnip").change_choice(-1)
                        end
                    end,
                    mode = { "i", "s" }
                }
            },
            config = function()
                local snippets_folder = vim.fn.stdpath "config" .. "/lua/plugins/completions/snippets/"

                vim.api.nvim_create_user_command("LuaSnipEdit", function()
                    require("luasnip.loaders.from_lua").edit_snippet_files()
                end, {})

                local types = require "luasnip.util.types"
                local options = {
                    history = true,            -- keep around last snippet local to jump back
                    updateevents = "TextChanged,TextChangedI", -- update changes as you type
                    enable_autosnippets = true,
                    ext_opts = {
                        [types.choiceNode] = { active = { virt_text = { { "  ●" } } } },
                    },
                }

                require("luasnip").config.set_config(options)

                require("luasnip.loaders.from_lua").lazy_load { paths = snippets_folder or "" }
                require("luasnip.loaders.from_vscode").lazy_load()

                vim.api.nvim_create_autocmd("InsertLeave", {
                    callback = function()
                        if
                            require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                            and not require("luasnip").session.jump_active
                        then
                            require("luasnip").unlink_current()
                        end
                    end,
                })
            end,
        },
    },
    config = function()
        local cmp = require "cmp"
        local luasnip = require "luasnip"
        local icons = require("utils.icons").icons
        local cmp_ui = require("config.user").plugin_configs.cmp
        local cmp_style = cmp_ui.style

        local field_arrangement = {
            atom = { "kind", "abbr", "menu" },
            atom_colored = { "kind", "abbr", "menu" },
        }

        local formatting_style = {
            -- default fields order i.e completion word + item.kind + item.kind icons
            fields = field_arrangement[cmp_style] or { "abbr", "kind", "menu" },
            format = function(entry, item)
                local icons = icons.kind
                local icon
                icon = (cmp_ui.icons and icons[item.kind]) or ""

                if cmp_style == "atom" or cmp_style == "atom_colored" then
                    icon = " " .. icon .. " "
                    item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
                    item.kind = icon
                else
                    icon = cmp_ui.lspkind_text and (" " .. icon .. " ") or icon
                    item.kind = string.format("%s %s", icon, cmp_ui.lspkind_text and item.kind or "")
                end
                if item.kind == "Copilot" or entry.source.name == "copilot" then
                    item.menu = cmp_ui.lspkind_text and "   (Copilot)" or ""
                    item.kind = cmp_ui.icons and "  "
                end
                if entry.source.name == "cmp_tabnine" or item.kind == "cmp_tabnine" then
                    item.menu = cmp_ui.lspkind_text and "   (Tabnine)" or ""
                    item.kind = cmp_ui.icons and "  "
                end
                if entry.source.name == "luasnip" or item.kind == "luasnip" then
                    item.menu = cmp_ui.lspkind_text and "   (Snippet)" or ""
                    item.kind = cmp_ui.icons and "  "
                end

                return item
            end,
        }
        local function border(hl_name)
            return {
                { "╭", hl_name },
                { "─", hl_name },
                { "╮", hl_name },
                { "│", hl_name },
                { "╯", hl_name },
                { "─", hl_name },
                { "╰", hl_name },
                { "│", hl_name },
            }
        end

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
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
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
                { name = "nvim_lua",},
                -- { name = "dynamic",          group_index = 2 },
                { name = "cmp_tabnine",      group_index = 2 },
                { name = "cmp_openai_codex", group_index = 2 },
                { name = "path",             group_index = 2 },
                { name = "buffer",           group_index = 2 },
                { name = "neosnippet" },
            },
            formatting = formatting_style,
            confirm_opts = { behavior = cmp.ConfirmBehavior.Replace, select = false },
            window = {
                completion = {
                    side_padding = (cmp_style ~= "atom" and cmp_style ~= "atom_colored") and 1 or 0,
                    winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
                    scrollbar = false,
                },
                documentation = {
                    border = border "CmpDocBorder",
                    winhighlight = "Normal:CmpDoc",
                },
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
