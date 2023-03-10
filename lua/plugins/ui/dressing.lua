return {
    "stevearc/dressing.nvim",
    enabled = vim.g.plugin_enabled.dressing,
    event = "VeryLazy",
    opts = {
        input = { relative = "editor" },
        select = { backend = { "telescope", "fzf", "builtin" } }
    }
}
