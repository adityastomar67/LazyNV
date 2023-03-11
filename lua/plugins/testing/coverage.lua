return {
    "andythigpen/nvim-coverage",
    enabled = vim.g.plugin_enabled.nvim_coverage,
    event = "VeryLazy",
    cmd = { "Coverage" },
    config = true,
}
