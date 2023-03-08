local User = {}

User.completion = true
User.transparency = true
User.diagnostic = true
User.colorscheme = "sonokai"
User.openai_path = vim.env.HOME .. "/.config/openai-codex/env"
User.plugins = {
    aerial = false,
    tree_sitter = true,
    nvim_cmp = true,
    telescope = true,
    project = false,
}

return User
