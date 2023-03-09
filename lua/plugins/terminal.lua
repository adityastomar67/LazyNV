return {
    "akinsho/toggleterm.nvim",
    enabled = plugin_enabled.toggleterm,
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
        size            = 13,
        open_mapping    = [[<c-\>]],
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor  = "1",
        start_in_insert = true,
        persist_size    = true,
        direction       = "horizontal",
        highlights      = {
            Normal      = { guibg = "#0f0f0f" },
            NormalFloat = { guibg = "#18181a" },
            FloatBorder = { guifg = "#18181a", guibg = "#18181a" },
        },
        float_opts = {
            border   = "curved",
            winblend = 3,
        },
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)
    end
}
