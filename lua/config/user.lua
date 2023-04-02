local User                      = {}

User.completion                 = true
User.transparency               = true
User.diagnostic                 = true
User.colorscheme                = "onedark"
User.openai_api_path            = vim.env.HOME .. "/.config/openai-codex/env"
User.plugins                    = {
    alpha_nvim       = true,
    aerial           = false,
    copliot          = true,
    treesitter       = true,
    vim_surround     = false,
    lspsaga          = false,
    nvim_cmp         = true,
    nvim_dap         = false,
    noice            = false,
    neogen           = false,
    vim_test         = false,
    neotest          = false,
    overseer         = false,
    nvim_coverage    = false,
    nvim_autopairs   = true,
    colorscheme      = {
        sonokai    = false,
        onedark    = true,
        catppuccin = false,
        gruvbox    = true,
        tokyonight = true,
        everforest = false,
        edge       = false,
    },
    toggleterm       = true,
    tabout           = false,
    leap             = false,
    mini             = {
        map       = false,
        move      = false,
        ai        = false,
        bufremove = false,
        animate   = false,
        comment   = false
    },
    gitsigns         = true,
    fidget           = false,
    neogit           = false,
    diffview         = false,
    vim_fugitive     = false,
    legendary        = false,
    whichkey         = true,
    codeium          = false,
    vim_gist         = false,
    harpoon          = false,
    mkdnflow         = false,
    nvim_ufo         = false,
    flit             = false,
    cmp_copilot      = false,
    cmp_dynamic      = true,
    cmp_tabnine      = true,
    inc_rename       = false,
    telescope        = true,
    project          = false,
    hydra            = false,
    LuaSnip          = true,
    chatgpt          = false,
    cheatsheet       = true,
    neural           = true,
    styler           = false,
    cheat_sh         = true,
    staline          = true,
    lualine          = false,
    indent_blankline = false,
    nvim_notify      = true,
    dial             = false,
    numb             = false,
    dressing         = false,
    vim_matchup      = false,
    italicize        = true,
    indentscope      = false,
    bufferline       = false,
    todo_comments    = true,
    neotree          = true,
    illuminate       = false,
    regexplainer     = false,
    hlargs           = false,
    hlslens          = false,
    nvim_spectre     = false,
    nvim_bqf         = false,
    refactoring      = false,
    persistence      = false,
    vim_startuptime  = false,
}
User.plugin_configs             = {
    cmp = {
        icons = true,
        lspkind_text = true,
        style = "atom_colored",       -- default/flat_light/flat_dark/atom/atom_colored
        border_color = "grey_fg",     -- only applicable for "default" style
        selected_item_bg = "colored", -- colored / simple
    },
}
User.ensure_installed_languages = {
    -- "bash",
    -- "c",
    -- "cpp",
    -- "help",
    -- "html",
    -- "javascript",
    -- "json",
    "lua",
    -- "markdown",
    -- "markdown_inline",
    -- "python",
    -- "query",
    -- "regex",
    -- "tsx",
    -- "typescript",
    -- "vim",
    -- "yaml",
    -- "sql",
    -- "regex",
}
User.mason_installed            = {
    "lua-language-server", "emmet-ls", "stylua"
}

return User
