return {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    enabled = vim.g.plugin_enabled.LuaSnip,
    dependencies = {
        -- {
        --     "adityastomar67/LuaSnip-snippets",
        --     config = function()
        --         require("luasnip.loaders.from_lua").lazy_load()
        --     end
        -- },
        {
            "adityastomar67/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        -- {
        --     "honza/vim-snippets",
        --     config = function()
        --         require("luasnip.loaders.from_snipmate").lazy_load()

        --         -- One peculiarity of honza/vim-snippets is that the file with the global snippets is _.snippets, so global snippets
        --         -- are stored in `ls.snippets._`.
        --         -- We need to tell luasnip that "_" contains global snippets:
        --         require("luasnip").filetype_extend("all", {"_"})
        --     end
        -- }
    },
    build = "make install_jsregexp",
    opts = { history = true, delete_check_events = "TextChanged" },
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
    config = function(_, opts)
        require("luasnip").setup(opts)

        local snippets_folder = vim.fn.stdpath "config" .. "/lua/plugins/completions/snippets/"
        require("luasnip.loaders.from_lua").lazy_load {
            paths = snippets_folder,
        }

        vim.api.nvim_create_user_command("LuaSnipEdit", function()
            require("luasnip.loaders.from_lua").edit_snippet_files()
        end, {})

        local types = require "luasnip.util.types"
        require("luasnip").config.set_config {
            history = true,                             -- keep around last snippet local to jump back
            updateevents = "TextChanged,TextChangedI", -- update changes as you type
            enable_autosnippets = true,
            ext_opts = {
                [types.choiceNode] = { active = { virt_text = { { "  ●" } } } },
            },
        }
    end,
}
