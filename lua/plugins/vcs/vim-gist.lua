return {
    "mattn/vim-gist",
    enabled = vim.g.plugin_enabled.vim_gist,
    dependencies = { "mattn/webapi-vim" },
    cmd = { "Gist" },
    config = function()
        vim.g.gist_open_browser_after_post = 1
    end,
}
