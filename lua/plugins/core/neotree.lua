return {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = vim.g.plugin_enabled.neotree,
    event = "VeryLazy",
    cmd = "Neotree",
    deactivate = function()
        vim.cmd [[Neotree close]]
    end,
    init = function()
        vim.g.neo_tree_remove_legacy_commands = 1
        if vim.fn.argc() == 1 then
            local stat = vim.loop.fs_stat(vim.fn.argv(0))
            if stat and stat.type == "directory" then
                require "neo-tree"
            end
        end
    end,
    opts = {
        filesystem = {
            bind_to_cwd = false,
            follow_current_file = true,
        },
        window = {
            mappings = {
                ["<space>"] = "none",
                ["h"]       = "close_node",
                ["l"]       = "open",
            },
        },
    },
}
