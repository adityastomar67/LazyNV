return {
    "zbirenbaum/copilot-cmp",
    enabled = plugin_enabled.cmp_copilot,
    dependencies = { "copilot.lua" },
    opts  = {
        suggestion = { enabled = false },
        panel      = { enabled = false },
        formatters = {
            label       = require("copilot_cmp.format").format_label_text,
            insert_text = require("copilot_cmp.format").remove_existing,
            preview     = require("copilot_cmp.format").deindent,
        },
    },
    config = function(_, opts)
        local copilot = require("copilot_cmp")
        copilot.setup(opts)
    end,
}
