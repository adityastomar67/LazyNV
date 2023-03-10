return {
    "adityastomar67/italicize",
    enabled = vim.g.plugin_enabled.italicize,
    opts = {
        transparency = true,
        italics      = true,
    },
    config = function(_, opts)
        require("italicize").setup(opts)
    end
}
