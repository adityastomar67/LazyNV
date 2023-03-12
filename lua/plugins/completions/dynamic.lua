return {
    "uga-rosa/cmp-dynamic",
    enabled = vim.g.plugin_enabled.cmp_dynamic,
    event = "VeryLazy",
    opts = function()
        local Date = require "cmp_dynamic.utils.date"
        return {
            {
                label = "today",
                insertText = 1,
                cb = {
                    function()
                        return os.date "%Y/%m/%d"
                    end,
                },
                cache = true, -- default: false
            },
            {
                label = "next Monday",
                insertText = 1,
                cb = {
                    function()
                        return Date.new():add_date(7):day(1):format "%Y/%m/%d"
                    end,
                },
            },
            {
                label = "next Tuesday",
                insertText = 1,
                cb = {
                    function()
                        return Date.new():add_date(7):day(2):format "%Y/%m/%d"
                    end,
                },
            },
            {
                label = "next Wednesday",
                insertText = 1,
                cb = {
                    function()
                        return Date.new():add_date(7):day(3):format "%Y/%m/%d"
                    end,
                },
            },
            {
                label = "next Thursday",
                insertText = 1,
                cb = {
                    function()
                        return Date.new():add_date(7):day(4):format "%Y/%m/%d"
                    end,
                },
            },
            {
                label = "next Friday",
                insertText = 1,
                cb = {
                    function()
                        return Date.new():add_date(7):day(5):format "%Y/%m/%d"
                    end,
                },
            },
            {
                label = "next Saturday",
                insertText = 1,
                cb = {
                    function()
                        return Date.new():add_date(7):day(6):format "%Y/%m/%d"
                    end,
                },
            },
            {
                label = "next Sunday",
                insertText = 1,
                cb = {
                    function()
                        return Date.new():add_date(7):day(0):format "%Y/%m/%d"
                    end,
                },
            },
        }
    end,
    config = function(_, opts)
        local dynamic = require("cmp_dynamic")
        dynamic.register(opts)
    end,
}
