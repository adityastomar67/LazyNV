return {
    "nvim-telescope/telescope.nvim",
    enabled = vim.g.plugin_enabled.telescope,
    dependencies = {
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-telescope/telescope-media-files.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-telescope/telescope-dap.nvim",
        "xiyaowong/telescope-emoji.nvim",
        "nvim-telescope/telescope-project.nvim",
        "cljoly/telescope-repo.nvim",
        "nvim-telescope/telescope-frecency.nvim",
        "kkharji/sqlite.lua",
    },
    cmd = "Telescope",
    keys = {
        {
            "<leader><space>",
            require("utils.telescope").find_files,
            desc = "Find Files"
        },
        {
            "<leader>fo",
            "<cmd>Telescope frecency theme=dropdown previewer=false<cr>",
            desc = "Recent"
        },
        { "<leader>ff", require("utils.telescope").find_files, desc = "Find Files" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>",          desc = "Buffers" },
        { "<leader>fr", "<cmd>Telescope file_browser<cr>",     desc = "Browser" },
        { "<leader>ps", "<cmd>Telescope repo list<cr>",        desc = "Search" },
        { "<leader>hs", "<cmd>Telescope help_tags<cr>",        desc = "Search" },
        {
            "<leader>pp",
            function()
                require("telescope").extensions.project.project { display_type = "minimal" }
            end,
            desc = "List"
        },
        { "<leader>sw", "<cmd>Telescope live_grep<cr>", desc = "Workspace" },
        {
            "<leader>sb",
            function()
                require("telescope.builtin").current_buffer_fuzzy_find()
            end,
            desc = "Buffer"
        },
        { "<leader>vo", "<cmd>Telescope aerial<cr>",    desc = "Code Outline" },
        {
            "<leader>zc",
            function()
                require("telescope.builtin").colorscheme({
                    enable_preview = true
                })
            end,
            desc = "Colorscheme"
        }
    },
    config = function(_, _)
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local actions_layout = require("telescope.actions.layout")
        local mappings = {
            i = {
                ["<C-n>"]      = actions.cycle_history_next,
                ["<C-p>"]      = actions.cycle_history_prev,
                ["<C-j>"]      = actions.move_selection_next,
                ["<C-k>"]      = actions.move_selection_previous,
                ["<C-c>"]      = actions.close,
                ["<Down>"]     = actions.move_selection_next,
                ["<Up>"]       = actions.move_selection_previous,
                ["<CR>"]       = actions.select_default,
                ["<C-x>"]      = actions.select_horizontal,
                ["<C-v>"]      = actions.select_vertical,
                ["<C-t>"]      = actions.select_tab,
                ["<C-u>"]      = actions.preview_scrolling_up,
                ["<C-d>"]      = actions.preview_scrolling_down,
                ["<PageUp>"]   = actions.results_scrolling_up,
                ["<PageDown>"] = actions.results_scrolling_down,
                ["<Tab>"]      = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"]    = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"]      = actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"]      = actions.send_selected_to_qflist + actions.open_qflist,
                ["<C-l>"]      = actions.complete_tag,
                ["<C-_>"]      = actions.which_key,     -- keys from pressing <C-/>
            },
            n = {
                ["q"]          = actions.close,
                ["<esc>"]      = actions.close,
                ["<CR>"]       = actions.select_default,
                ["<C-x>"]      = actions.select_horizontal,
                ["<C-v>"]      = actions.select_vertical,
                ["<C-t>"]      = actions.select_tab,
                ["<Tab>"]      = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"]    = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"]      = actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"]      = actions.send_selected_to_qflist + actions.open_qflist,
                ["j"]          = actions.move_selection_next,
                ["k"]          = actions.move_selection_previous,
                ["H"]          = actions.move_to_top,
                ["M"]          = actions.move_to_middle,
                ["L"]          = actions.move_to_bottom,
                ["<Down>"]     = actions.move_selection_next,
                ["<Up>"]       = actions.move_selection_previous,
                ["gg"]         = actions.move_to_top,
                ["G"]          = actions.move_to_bottom,
                ["<C-u>"]      = actions.preview_scrolling_up,
                ["<C-d>"]      = actions.preview_scrolling_down,
                ["<PageUp>"]   = actions.results_scrolling_up,
                ["<PageDown>"] = actions.results_scrolling_down,
                ["?"]          = actions.which_key,
            },
        }
        local opts = {
            defaults = {
                riprep_arguments       = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                },
                prompt_prefix          = require("utils.lspkind").icons.ui.Search,
                selection_caret        = "  ",
                entry_prefix           = "  ",
                initial_mode           = "insert",
                selection_strategy     = "reset",
                sorting_strategy       = "ascending",
                layout_strategy        = "horizontal",
                layout_config          = {
                    horizontal     = {
                        prompt_position = "top",
                        preview_width   = 0.55,
                        results_width   = 0.8,
                    },
                    vertical       = { mirror = false },
                    width          = 0.80,
                    height         = 0.85,
                    preview_cutoff = 120,
                },
                file_sorter            = require("telescope.sorters").get_fuzzy_file,
                file_ignore_patterns   = {
                    "luadisabled",
                    "vimdisabled",
                    "forks",
                    ".backup",
                    ".swap",
                    ".langservers",
                    ".session",
                    ".undo",
                    ".git/",
                    "node_modules",
                    "vendor",
                    ".cache",
                    ".vscode-server",
                    ".Desktop",
                    ".Documents",
                    "classes",
                    "quantumimage",
                },
                generic_sorter         = require("telescope.sorters").get_generic_fuzzy_sorter,
                path_display           = { "truncate" },
                winblend               = 0,
                border                 = {},
                borderchars            = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons         = true,
                set_env                = { ["COLORTERM"] = "truecolor" },     -- default = nil,
                file_previewer         = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer         = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer       = require("telescope.previewers").vim_buffer_qflist.new,
                buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
                mappings               = mappings,
                extensions             = {
                    emoji = {
                        action = function(emoji)
                            vim.api.nvim_put({ emoji.value }, "c", false, true)
                        end,
                    },
                    media_files = {
                        filetypes = { "png", "webp", "jpg", "jpeg" },
                        find_cmd  = "rg",
                    },
                    file_browser = {
                        hijack_netrw = true,
                    },
                },
                extensions_list        = { "themes", "terms" },
            }
        }

        telescope.setup(opts)
        telescope.load_extension("emoji")
        telescope.load_extension("media_files")
        telescope.load_extension("ui-select")
        telescope.load_extension("project")
        telescope.load_extension("fzf")
        telescope.load_extension("file_browser")
        telescope.load_extension("project")
        telescope.load_extension("aerial")
        telescope.load_extension("dap")
        telescope.load_extension("frecency")
    end
}
