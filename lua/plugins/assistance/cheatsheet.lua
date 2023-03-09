return {
    "sudormrfbin/cheatsheet.nvim",
    enabled = plugin_enabled.cheatsheet,
    event = "VeryLazy",
    opts = {
        bundled_cheatsheets = true,
        bundled_plugin_cheatsheets = true,
        include_only_installed_plugins = true,
        telescope_mappings = {
            ["<CR>"] = require("cheatsheet.telescope.actions").select_or_fill_commandline,
            ["<A-CR>"] = require("cheatsheet.telescope.actions").select_or_execute,
            ["<C-Y>"] = require("cheatsheet.telescope.actions").copy_cheat_value,
            ["<C-E>"] = require("cheatsheet.telescope.actions").edit_user_cheatsheet
        }
    },
    config = function(_, opts) require("cheatsheet").setup(opts) end
}