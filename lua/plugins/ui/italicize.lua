return {
    "adityastomar67/italicize",
    enabled = vim.g.plugin_enabled.italicize,
    opts = {
        transparency       = true,
        italics            = true,
        transparent_groups = {
            "Todo",
            "TodoSignDONE",
            "TodoSignFIX ",
            "TodoSignHACK",
            "TodoSignNOTE",
            "TodoSignPERF",
            "TodoSignTEST",
            "TodoSignTODO",
            "TodoSignWARN",
        }
    },
    config = function(_, opts)
        require("italicize").setup(opts)
    end
}
