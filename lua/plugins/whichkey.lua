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
        wk.register({
            mode = { "n" },
            ["="] = { "<cmd>lua vim.lsp.buf.format { async = true }<CR>", "Format Document" },
            ["_"] = { "<C-w>s", "Split Horizontally" },
            ["|"] = { "<C-w>v", "Split Vertically" },
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
            I = { '<cmd>lua require("utils.toggler").toggle()<CR>', "Toggle Inverse" },
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

        local function code_keymap()
            vim.api.nvim_create_autocmd("FileType", {
                pattern  = "*",
                callback = function()
                    vim.schedule(CodeRunner)
                end,
            })

            function CodeRunner()
                local bufnr      = vim.api.nvim_get_current_buf()
                local ft         = vim.api.nvim_buf_get_option(bufnr, "filetype")
                local fname      = vim.fn.expand("%:p:t")
                local keymap_c   = {} -- normal key map
                local keymap_c_v = {} -- visual key map

                if ft == "python" then
                    keymap_c = {
                        name = "Code",
                        i = { "<cmd>cexpr system('refurb --quiet ' . shellescape(expand('%'))) | copen<cr>", "Inspect" },
                        r = {
                            "<cmd>update<cr><cmd>lua require('core.utils.assistance').open_term([[python3 ]] .. vim.fn.shellescape(vim.fn.getreg('%'), 1), {direction = 'float'})<cr>",
                            "Run",
                        },
                        m = { "<cmd>TermExec cmd='nodemon -e py %'<cr>", "Monitor" },
                    }
                elseif ft == "sh" then
                    keymap_c = {
                        name = "Code",
                        r = {
                            "<cmd>update<cr><cmd>lua require('core.utils.assistance').open_term([[chmod +x ]] .. vim.fn.shellescape(vim.fn.getreg('%'), 1) .. [[ && ./]] .. vim.fn.shellescape(vim.fn.getreg('%'), 1), {direction = 'float'})<cr>",
                            "Run",
                        },
                        c = {
                            "<cmd>update<cr><cmd>lua require('core.utils.assistance').open_term([[shellcheck --color=always ]] .. vim.fn.shellescape(vim.fn.getreg('%'), 1) .. [[ | bat]], {direction = 'float'})<cr>",
                            "ShellCheck",
                        },
                        f = {
                            "<cmd>update<cr><cmd>silent !shfmt -i 4 -w %<cr>",
                            "Shfmt",
                        },
                    }
                elseif ft == "cpp" then
                    keymap_c = {
                        name = "Code",
                        r = {
                            "<cmd>update<cr><cmd>lua require('core.utils.assistance').open_term([[g++ -std=c++20 ]] .. vim.fn.shellescape(vim.fn.getreg('%'), 1) .. [[ && ./a.out && rm -f a.out]], {direction = 'float'})<cr>",
                            "Run",
                        },
                    }
                elseif ft == "lua" then
                    keymap_c = {
                        name = "Code",
                        r = {
                            "<cmd>update<cr><cmd>lua require('core.utils.assistance').open_term([[lua ]] .. vim.fn.shellescape(vim.fn.getreg('%'), 1), {direction = 'float'})<cr>",
                            "Run",
                        },
                    }
                elseif ft == "rust" then
                    keymap_c = {
                        name = "Code",
                        r    = { "<cmd>execute 'Cargo run' | startinsert<cr>", "Run" },
                        D    = { "<cmd>RustDebuggables<cr>", "Debuggables" },
                        h    = { "<cmd>RustHoverActions<cr>", "Hover Actions" },
                        R    = { "<cmd>RustRunnables<cr>", "Runnables" },
                    }
                elseif ft == "json" then
                    keymap_c = { name = "Code", p = { "<cmd>update<cr><cmd>%!jq<cr>", "Prettify" } }
                elseif ft == "go" then
                    keymap_c = { name = "Code", r = { "<cmd>GoRun<cr>", "Run" } }
                elseif ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
                    keymap_c = {
                        name = "Code",
                        o    = { "<cmd>TypescriptOrganizeImports<cr>", "Organize Imports" },
                        r    = { "<cmd>TypescriptRenameFile<cr>", "Rename File" },
                        i    = { "<cmd>TypescriptAddMissingImports<cr>", "Import Missing" },
                        F    = { "<cmd>TypescriptFixAll<cr>", "Fix All" },
                        u    = { "<cmd>TypescriptRemoveUnused<cr>", "Remove Unused" },
                        R    = { "<cmd>lua require('config.neotest').javascript_runner()<cr>", "Choose Test Runner" },
                    }
                elseif ft == "java" then
                    keymap_c = {
                        name = "Code",
                        o    = { "<cmd>lua require('jdtls').organize_imports()<cr>", "Organize Imports" },
                        v    = { "<cmd>lua require('jdtls').extract_variable()<cr>", "Extract Variable" },
                        c    = { "<cmd>lua require('jdtls').extract_constant()<cr>", "Extract Constant" },
                        t    = { "<cmd>lua require('jdtls').test_class()<cr>", "Test Class" },
                        n    = { "<cmd>lua require('jdtls').test_nearest_method()<cr>", "Test Nearest Method" },
                    }
                    keymap_c_v = {
                        name = "Code",
                        v    = { "<cmd>lua require('jdtls').extract_variable(true)<cr>", "Extract Variable" },
                        c    = { "<cmd>lua require('jdtls').extract_constant(true)<cr>", "Extract Constant" },
                        m    = { "<cmd>lua require('jdtls').extract_method(true)<cr>", "Extract Method" },
                    }
                end

                if fname == "package.json" then
                    keymap_c.v = { "<cmd>lua require('package-info').show()<cr>", "Show Version" }
                    keymap_c.c = { "<cmd>lua require('package-info').change_version()<cr>", "Change Version" }
                end

                if fname == "Cargo.toml" then
                    keymap_c.u = { "<cmd>lua require('crates').upgrade_all_crates()<cr>", "Upgrade All Crates" }
                end

                if next(keymap_c) ~= nil then
                    local k = { c = keymap_c }
                    local o = {
                        mode    = "n",
                        silent  = true,
                        noremap = true,
                        buffer  = bufnr,
                        prefix  = "<leader>",
                        nowait  = true,
                    }
                    wk.register(k, o)
                end

                if next(keymap_c_v) ~= nil then
                    local k = { c = keymap_c_v }
                    local o = {
                        mode    = "v",
                        silent  = true,
                        noremap = true,
                        buffer  = bufnr,
                        prefix  = "<leader>",
                        nowait  = true,
                    }
                    wk.register(k, o)
                end
            end
        end

        code_keymap()
    end,
}
