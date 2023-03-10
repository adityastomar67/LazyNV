return {
    "tpope/vim-fugitive",
    enabled = vim.g.plugin_enabled.vim_fugitive,
    cmd = { "Git", "GBrowse", "Gdiffsplit", "Gvdiffsplit" },
    dependencies = {
        "tpope/vim-rhubarb",
    },
}
