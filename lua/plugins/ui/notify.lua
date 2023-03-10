return {
    "rcarriga/nvim-notify",
    enabled = vim.g.plugin_enabled.nvim_notify,
    event = "VeryLazy",
    opts = {
        background_colour = "#000000",
        timeout = 3000,
        max_height = function()
            return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
            return math.floor(vim.o.columns * 0.75)
        end
    },
    config = function(_, opts)
        require("notify").setup(opts)
        vim.notify = require "notify"
    end
}
