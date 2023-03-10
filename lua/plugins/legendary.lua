return {
    "mrjones2014/legendary.nvim",
    enabled = vim.g.plugin_enabled.legendary,
    keys = {
        { "<C-S-p>",    "<cmd>Legendary<cr>", desc = "Legendary" },
        { "<leader>hc", "<cmd>Legendary<cr>", desc = "Command Palette" },
    },
    opts = {
        which_key = { auto_register = true },
    },
}
