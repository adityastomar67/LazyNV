local User                      = {}

User.completion                 = true
User.transparency               = true
User.diagnostic                 = true
User.highlighturl_enabled       = true
User.colorscheme                = "onedark"
User.openai_api_path            = vim.env.HOME .. "/.config/openai-codex/env"
User.plugins                    = {
    copliot          = true,
    treesitter       = true,
    nvim_cmp         = true,
    gitsigns         = true,
    cmp_tabnine      = true,
    telescope        = true,
    LuaSnip          = true,
    nvim_notify      = true,
    todo_comments    = true,
    neotree          = true,
    nvim_autopairs   = false,
    staline          = false,
    alpha_nvim       = false,
    whichkey         = false,
    cmp_dynamic      = false,
    inc_rename       = false,
    cheatsheet       = false,
    neural           = false,
    cheat_sh         = false,
    italicize        = false,
    aerial           = false,
    vim_surround     = false,
    lspsaga          = false,
    nvim_dap         = false,
    noice            = false,
    neogen           = false,
    vim_test         = false,
    neotest          = false,
    overseer         = false,
    nvim_coverage    = false,
    colorscheme      = {
        onedark    = true,
        gruvbox    = true,
        tokyonight = true,
        sonokai    = false,
        catppuccin = false,
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
    fidget           = false,
    neogit           = false,
    diffview         = false,
    vim_fugitive     = false,
    legendary        = false,
    codeium          = false,
    vim_gist         = false,
    harpoon          = false,
    mkdnflow         = false,
    nvim_ufo         = false,
    flit             = false,
    cmp_copilot      = false,
    project          = false,
    hydra            = false,
    chatgpt          = false,
    styler           = false,
    lualine          = false,
    indent_blankline = false,
    dial             = false,
    numb             = false,
    dressing         = false,
    vim_matchup      = false,
    indentscope      = false,
    bufferline       = false,
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
    "bash",
    "c",
    "cpp",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "tsx",
    "typescript",
    "vim",
    "yaml",
    "sql",
}
User.mason_installed = {
    "lua-language-server", "bash-language-server","shellcheck", 
    "emmet-ls", "stylua", "clangd", "typescript-language-server", 
    "tailwindcss-language-server", "pyright", "black"
}

return User
