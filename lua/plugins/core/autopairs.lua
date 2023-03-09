return {
    "windwp/nvim-autopairs",
    enabled = plugin_enabled.nvim_autopairs,
    event = "InsertEnter",
    config = function()
        local npairs = require "nvim-autopairs"
        npairs.setup { check_ts = true }
    end
}
