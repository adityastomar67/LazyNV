local User                      = {}

User.completion                 = true
User.transparency               = true
User.diagnostic                 = true
User.colorscheme                = "sonokai"
User.openai_api_path            = vim.env.HOME .. "/.config/openai-codex/env"
User.plugins                    = {
    alpha_nvim       = true,
    aerial           = false,
    copliot          = true,
    treesitter       = true,
    vim_surround = false,
    nvim_cmp         = true,
    nvim_dap = false,
    neogen           = false,
    vim_test = false,
    neotest = false,
    overseer = false,
    nvim_coverage = false,
    nvim_autopairs   = true,
    colorscheme      = {
        sonokai    = true,
        onedark    = false,
        catppuccin = false,
        gruvbox    = true,
        tokyonight = true,
        everforest = false,
        edge       = false,
    },
    toggleterm       = true,
    tabout           = true,
    leap             = true,
    mini             = {
        map       = true,
        move      = true,
        ai        = true,
        bufremove = true,
        animate   = true,
        comment   = true
    },
    gitsigns         = true,
    flit             = true,
    cmp_copilot      = true,
    cmp_dynamic      = true,
    cmp_tabnine      = true,
    telescope        = true,
    project          = false,
    hydra            = false,
    LuaSnip          = true,
    chatgpt          = true,
    cheatsheet       = true,
    neural           = true,
    styler           = true,
    cheat_sh         = true,
    staline          = true,
    lualine          = true,
    indent_blankline = false,
    indentscope      = true,
    bufferline       = false,
    todo_comments    = true,
    neotree          = true,
    illuminate       = true,
    hlargs           = false,
    hlslens          = true,
    nvim_spectre     = false,
    nvim_bqf         = true,
    persistence      = false,
    vim_startuptime  = false,
}
User.ensure_installed_languages = {
    "bash", "c", "cpp", "help", "html", "javascript", "json", "lua",
    "markdown", "markdown_inline", "python", "query", "regex",
    "tsx", "typescript", "vim", "yaml", "sql",
}

return User
