return {
    "folke/which-key.nvim",
    enabled = vim.g.plugin_enabled.whichkey,
    dependencies = {
        "mrjones2014/legendary.nvim",
    },
    event = "BufEnter",
    config = function()
        local wk = require "which-key"
        wk.setup {
            show_help = true,
            plugins = { spelling = true },
            key_labels = { ["<leader>"] = "SPC" },
            triggers = "auto",
        }
        --   wk.register({mode = {"v"},
        -- }, { prefix = "<leader>" })
        wk.register({
            mode = { "n" },
            a = {
                name = "Coding Assistance",
                a = { "<cmd>ChatGPT<CR>", " ChatGPT" },
                g = { "<cmd>Copilot panel<CR>", " Copilot Panel" },
                b = { "<cmd>Cheatsheet<CR>", " Builtin Cheats" },
                n = { "<cmd>NeuralPrompt<CR>", " NeuralPrompt" },
                c = { "<cmd>lua require('utils.assistance').cht()<CR>", " Cheat.sh" },
                e = { "<cmd>lua require('utils.assistance').shell_gpt()<CR>", " Shell-GPT" },
                s = { "<cmd>lua require('utils.assistance').so_input()<CR>", " StackOverflow" },
                i = { "<cmd>lua require('utils.assistance').interactive_cheatsheet_toggle()<CR>",
                    " Interactive Cheatsheet" },
                o = { "<cmd>lua require('utils.assistance').complete()<CR>", " OpenAI Codex" },
                t = { "<cmd>lua require('utils.assistance').howto()<CR>", " HowTo (Shell Helper and other!)" },
                h = { "<cmd>lua require('utils.assistance').howdoi()<CR>", " HowDoI" },
                p = { "<cmd>lua require('utils.assistance').project_info_toggle()<CR>", "冷 Project Info" },
            },
            T = {
                name = "Toggle Options",
                a = { "<cmd>set invlist<CR>", "Toggle Whitespace" },
                e = { "<cmd>ColorizerToggle<CR>", "Toggle Colorizer" },
                l = { "<cmd>Limelight!!<CR>", "Toggle LimeLight" },
                i = { "<cmd>set invcursorline<CR>", "Toggle Cursor Line" },
                o = { "<cmd>set invcursorcolumn<CR>", "Toggle Cursor Column" },
                f = { "<cmd>set invfoldenable<CR>", "Toggle Fold" },
                g = { "<cmd>set invspell<CR>", "Toggle Spell" },
                j = { "<cmd>set invrelativenumber<CR>", "Toggle Relative Numbers" },
                k = { "<cmd>set invwrap<CR>", "Toggle Wrap" },
                z = { "<cmd>set invrnu invnu<CR>", "Toggle Line Numbers" },
                m = { "<cmd>lua require'codewindow'.toggle_minimap()<CR>", "Toggle Minimap" },
                c = { '<cmd>lua require("utils.settings").toggle_cmp()<CR>', "Toggle Completions" },
                t = { '<cmd>lua require("utils.settings").toggle_transparency()<CR>', "Toggle Transparency" },
                d = { "<cmd>lua require('utils.settings').toggle_diagnostics()<CR>", "Toggle Inline Diagnostics" },
                u = { "<cmd>exe 'let HlUnderCursor=exists(\"HlUnderCursor\")?HlUnderCursor*-1+1:1'<CR>",
                    "Toggle Underline Cursor word" },
            },
        }, { prefix = "<leader>" })

        wk.register({
            mode = { "n", "v" },
            I = { '<cmd>lua require("utils.toggle").toggle()<CR>', "Toggle Inverse" },
            S = {
                name = "Text",
                a = { ":SimpleAlign ", "Align Text" },
                r = {
                    ":%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>",
                    "Replace All Instances",
                },
            },
            w = { "<cmd>update!<CR>", "Save" },
            -- stylua: ignore
            q = {
                name = "Quit",
                q = { function() require("utils").quit() end, "Quit", },
                t = { "<cmd>tabclose<cr>", "Close Tab" },
            },
            b = { name = "+Buffer" },
            d = { name = "+Debug" },
            f = { name = "+File" },
            h = { name = "+Help" },
            j = { name = "+Jump" },
            g = { name = "+Git", h = { name = "Hunk" }, t = { name = "Toggle" } },
            p = { name = "+Project" },
            t = { name = "+Test", N = { name = "Neotest" }, o = { "Overseer" } },
            v = { name = "+View" },
            z = { name = "+System" },
            -- stylua: ignore

            c = {
                name = "+Code",
                g = { name = "Annotation" },
                x = {
                    name = "Swap Next",
                    f = "Function",
                    p = "Parameter",
                    c = "Class",
                },
                X = {
                    name = "Swap Previous",
                    f = "Function",
                    p = "Parameter",
                    c = "Class",
                },
            },
        }, { prefix = "<leader>" })
    end,
}
