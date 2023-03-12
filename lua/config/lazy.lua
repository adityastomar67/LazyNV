--- Install lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
    return
end

lazy.setup {
    spec = {
        { import = "plugins" },
        { import = "plugins.assistance" },
        { import = "plugins.completions" },
        { import = "plugins.core" },
        { import = "plugins.lsp" },
        -- { import = "plugins.lsp.lang" },
        { import = "plugins.testing" },
        { import = "plugins.ui" },
        { import = "plugins.ui.colors" },
        { import = "plugins.vcs" },
    },
    lockfile = vim.fn.stdpath('config') .. '/lua/plugins/lock.json',
    state = vim.fn.stdpath('state') .. '/lazy/state.json',
    defaults = { lazy = true, version = nil },
    install = { missing = true, colorscheme = { "onedark", "tokyonight", "gruvbox" } },
    dev = { path = '~/Projects', patterns = jit.os:find "Windows" and {} or { "LazyNV" }, fallback = false, },
    checker = {
        enabled = true,
        notify = true,
        frequency = 3600,
    },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "netrw",
                "netrwFileHandlers",
                "loaded_remote_plugins",
                "loaded_tutor_mode_plugin",
                "netrwPlugin",
                "netrwSettings",
                "rrhelper",
                "spellfile_plugin",
                "tar",
                "tarPlugin",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
                "matchparen",
            },
        },
    },
    ui = {
        size = { width = 0.9, height = 0.8 }, -- a number <1 is a percentage., >1 is a fixed size
        wrap = true,                          -- wrap the lines in the ui
        border = 'none',                      -- Accepts same border values as |nvim_open_win()|.
        icons = {
            cmd = ' ',
            config = '',
            event = '',
            ft = ' ',
            init = ' ',
            import = ' ',
            keys = ' ',
            lazy = '󰒲 ',
            loaded = '●',
            not_loaded = '○',
            plugin = ' ',
            runtime = ' ',
            source = ' ',
            start = '',
            task = '✔ ',
            list = {
                '●',
                '➜',
                '★',
                '‒',
            },
        },
        browser = nil, ---@type string?
        throttle = 20, -- how frequently should the ui process render events
        custom_keys = {
            -- open lazygit log
            ['<localleader>l'] = function(plugin)
                require('lazy.util').float_term({ 'lazygit', 'log' }, {
                    cwd = plugin.dir,
                })
            end,
            -- open a terminal for the plugin dir
            ['<localleader>t'] = function(plugin)
                require('lazy.util').float_term(nil, {
                    cwd = plugin.dir,
                })
            end,
        },
    },
}

-- Keymap for launching Lazy instantly
vim.keymap.set("n", "<leader>zz", "<cmd>:Lazy<cr>", { desc = "Manage Plugins" })
