return {
    "dense-analysis/neural",
    enabled = plugin_enabled.neural,
    event = "VeryLazy",
    config = function()
        local api = require("utils").get_api_key()
        require("neural").setup({ open_ai = { api_key = api } })
    end
}
