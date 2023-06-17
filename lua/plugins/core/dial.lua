return {
    "monaqa/dial.nvim",
    enabled = vim.g.plugin_enabled.dial,
    keys = {
        "<C-a>", "<C-x>", { "<C-a>", "v" }, { "<C-x>", "v" }, { "g<C-a>", "v" },
        { "g<C-x>", "v" }
    },
    -- stylua: ignore
    init = function()
        vim.api.nvim_set_keymap("n", "<C-a>",
            require("dial.map").inc_normal(),
            { desc = "Increment", noremap = true })
        vim.api.nvim_set_keymap("n", "<C-x>",
            require("dial.map").dec_normal(),
            { desc = "Decrement", noremap = true })
        vim.api.nvim_set_keymap("v", "<C-a>",
            require("dial.map").inc_visual(),
            { desc = "Increment", noremap = true })
        vim.api.nvim_set_keymap("v", "<C-x>",
            require("dial.map").dec_visual(),
            { desc = "Decrement", noremap = true })
        vim.api.nvim_set_keymap("v", "g<C-a>",
            require("dial.map").inc_gvisual(),
            { desc = "Increment", noremap = true })
        vim.api.nvim_set_keymap("v", "g<C-x>",
            require("dial.map").dec_gvisual(),
            { desc = "Decrement", noremap = true })
    end
}
