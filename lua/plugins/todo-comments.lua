local icon = require("utils.icons").icons.todo

return {
    "folke/todo-comments.nvim",
    enabled = vim.g.plugin_enabled.todo_comments,
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    keys = {
        { "]t",         function() require("todo-comments").jump_next() end, desc = "Next ToDo" },
        { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous ToDo" },
        { "<leader>ct", "<cmd>TodoTrouble<cr>",                              desc = "ToDo (Trouble)" },
        { "<leader>cT", "<cmd>TodoTelescope<cr>",                            desc = "ToDo" },
    },
    opts = {
        signs          = true,
        sign_priority  = 8,
        keywords       = {
            FIX  = { icon = icon.FIX, color = "#C34043", alt   = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
            TODO = { icon = icon.TODO, color = "info" },
            DONE = { icon = icon.DONE, color = "done", alt = { "COMPLETE" } },
            HACK = { icon = icon.HACK, color = "warning" },
            WARN = { icon = icon.WARN, color = "error", alt = { "WARNING", "XXX" } },
            PERF = { icon = icon.PERF, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = icon.NOTE, color = "hint", alt = { "INFO" } }
        },
        merge_keywords = true,                     -- when true, custom keywords will be merged with the defaults
        highlight      = {
            before        = "",                    -- "fg" or "bg" or empty
            keyword       = "wide",                -- "fg", "bg", "wide" or empty.
            after         = "fg",                  -- "fg" or "bg" or empty
            pattern       = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
            comments_only = true,                  -- uses treesitter to match keywords in comments only
            max_line_len  = 400,                   -- ignore lines longer than this
            exclude       = {}                     -- list of file types to exclude highlighting
        },
        colors         = {
            error   = { "DiagnosticError"  , "ErrorMsg"  , "#DC2626" },
            warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
            info    = { "DiagnosticInfo"   , "#7FB4CA" },
            done    = { "DiagnosticDone"   , "#00A600" },
            hint    = { "DiagnosticHint"   , "#10B981" },
            default = { "Identifier"       , "#C34043" }
        },
        search         = {
            command = "rg",
            args = {
                "--color=never", "--no-heading", "--with-filename", "--line-number",
                "--column"
            },
            pattern = [[\b(KEYWORDS):]] -- ripgrep regex
        }
    },
    config = function(_, opts)
        require("todo-comments").setup(opts)
    end,
}
