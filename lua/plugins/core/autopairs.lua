return {
    "windwp/nvim-autopairs",
    enabled = vim.g.plugin_enabled.nvim_autopairs,
    event = "VeryLazy",
    config = function()
        local npairs = require "nvim-autopairs"
        npairs.setup { check_ts = true }
    end
}
