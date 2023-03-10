return {
    "TimUntersberger/neogit",
    enabled = vim.g.plugin_enabled.neogit,
    cmd = "Neogit",
    opts = {
        integrations = { diffview = true },
    },
    keys = {
        { "<leader>gs", "<cmd>Neogit kind=tab<cr>", desc = "Status" },
    },
}
