return {
    "andymass/vim-matchup",
    enabled = vim.g.plugin_enabled.vim_matchup,
    event = { "BufReadPost" },
    config = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end
}
