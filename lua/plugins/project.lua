return {
    "ahmedkhalf/project.nvim",
    enabled = vim.g.plugin_enabled.project,
    config = function()
        require("project_nvim").setup {
            detection_methods = { "pattern", "lsp" },
            patterns = { ".git" },
            ignore_lsp = { "null-ls" }
        }
    end
}
