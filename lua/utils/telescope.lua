local _, BUILTIN = pcall(require, "telescope.builtin")
local _, ACTIONS = pcall(require, "telescope.actions")
local Telescope = {}

Telescope.find_files = function()
    local opts   = {
        prompt_title         = "FILES",
        sorting_strategy     = "ascending",
        file_ignore_patterns = { "lua-language-server", "chromium" },
        previewer            = true,
        hidden               = true,
    }
    local status = pcall(BUILTIN.git_files, opts)
    if not status then BUILTIN.find_files(opts) end
end

Telescope.xdg_config = function()
    BUILTIN.find_files({
        prompt_title         = "XDG-CONFIG",
        find_command         = { "fd", "--no-ignore-vcs" },
        sorting_strategy     = "ascending",
        file_ignore_patterns = { "lua-language-server", "chromium" },
        cwd                  = "~/.dotfiles",
        layout_config        = { width = 0.7, height = 0.3 },
        results_height       = 20,
        hidden               = true,
        previewer            = false,
        borderchars          = {
            { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },
    })
end

Telescope.buffers = function()
    BUILTIN.buffers({
        prompt_title         = "BUFFERS",
        sorting_strategy     = "ascending",
        file_ignore_patterns = { "lua-language-server", "chromium" },
        previewer            = false,
        layout_config        = { width = 0.5, height = 0.3 },
        hidden               = true,
    })
end

Telescope.nvim_files = function()
    BUILTIN.find_files({
        prompt_title         = "NVIM-FILES",
        previewer            = false,
        find_command         = { "fd", "--no-ignore-vcs" },
        sorting_strategy     = "ascending",
        file_ignore_patterns = { ".git", "lua-language-server", "bin/" },
        cwd                  = "~/.config/nvim",
        hidden               = true,
    })
end

Telescope.search_dotfiles = function()
    BUILTIN.find_files({
        prompt_title     = "DOTFILES",
        find_command     = { "fd", "--no-ignore-vcs" },
        shorten_path     = true,
        sorting_strategy = "ascending",
        cwd              = vim.env.DOTFILES,
        hidden           = true,
        previewer        = false,
        layout_config    = { height = 0.3, width = 0.5 },
    })
end

Telescope.search_oldfiles = function()
    BUILTIN.oldfiles({
        prompt_title     = "RECENT-FILES",
        previewer        = false,
        shorten_path     = true,
        sorting_strategy = "ascending",
        hidden           = true,
        layout_config    = { height = 0.3, width = 0.5 },
    })
end

Telescope.grep_dotfiles = function()
    BUILTIN.live_grep({
        prompt_title     = "GREP-DOTFILES",
        shorten_path     = true,
        sorting_strategy = "ascending",
        cwd              = vim.env.DOTFILES,
        hidden           = true,
    })
end

Telescope.grep_wiki = function()
    BUILTIN.live_grep({
        hidden       = true,
        search_dirs  = { "~/.dotfiles/wiki" },
        prompt_title = "GREP-WIKI",
        path_display = { "smart" },
    })
end

Telescope.git_branches = function()
    BUILTIN.git_branches({
        prompt_title    = "GIT-BRANCHES",
        path_display    = { "smart" },
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<c-d>", ACTIONS.git_delete_branch)
            map("n", "dd"   , ACTIONS.git_delete_branch)
            return true
        end,
    })
end

Telescope.installed_plugins = function()
    BUILTIN.find_files({
        hidden       = true,
        cwd          = vim.fn.stdpath("data") .. "/site/pack/packer/start/",
        prompt_title = "INSTALLED-PLUGS",
        path_display = { "smart" },
    })
end

return Telescope
