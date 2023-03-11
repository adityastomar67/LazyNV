return {
    "zbirenbaum/copilot-cmp",
    enabled = vim.g.plugin_enabled.cmp_copilot,
    event = "VeryLazy",
    dependencies = { "copilot.lua" },
    config = function()
        require("copilot_cmp").setup({
        suggestion = { enabled = false },
        panel      = { enabled = false },
        formatters = {
            label       = require("copilot_cmp.format").format_label_text,
            insert_text = require("copilot_cmp.format").remove_existing,
            preview     = require("copilot_cmp.format").deindent,
        },
    })
    end,
}
