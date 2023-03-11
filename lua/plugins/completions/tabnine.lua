return {
    "tzachar/cmp-tabnine",
    enabled = vim.g.plugin_enabled.cmp_tabnine,
    event = "VeryLazy",
    build = "./install.sh",
    opts = {
        max_lines                = 1000,
        max_num_results          = 20,
        sort                     = true,
        run_on_every_keystroke   = true,
        snippet_placeholder      = "..",
        show_prediction_strength = false,
    },
    config = function(_, opts)
        local tabnine = require("cmp_tabnine.config")
        tabnine.setup(opts)
    end,
}
