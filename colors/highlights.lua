local telescope = {
    TelescopeBorder            = { fg = "#1b1f27", bg = "#1b1f27" },
    TelescopePromptBorder      = { fg = "#252931", bg = "#252931" },
    TelescopePromptNormal      = { fg = "#abb2bf", bg = "#252931" },
    TelescopePromptPrefix      = { fg = "#e06c75", bg = "#252931" },
    TelescopePreviewTitle      = { fg = "#1e222a", bg = "#98c379" },
    TelescopePromptTitle       = { fg = "#1e222a", bg = "#e06c75" },
    TelescopeResultsTitle      = { fg = "#1b1f27", bg = "#1b1f27" },
    TelescopeSelection         = { bg = "#252931", fg = "#abb2bf" },
    TelescopeNormal            = { bg = "#1b1f27" },
    TelescopeResultsDiffAdd    = { fg = "#98c379" },
    TelescopeResultsDiffChange = { fg = "#e7c787" },
    TelescopeResultsDiffDelete = { fg = "#e06c75" }
}
local cmp = {
    CmPmenu                  = { bg = "NONE" },
    CmpItemAbbr              = { fg = "#abb2bf" },
    CmpBorder                = { fg = "#42464e" },
    CmpItemAbbrMatch         = { fg = "#61afef", style = "bold" },
    CmpItemKind              = { fg = "#FFCC66", style = 'italic' },
    CmpDocBorder             = { fg = "#1b1f27", bg = "NONE" },
    PmenuSel                 = { fg = "NONE",    bg = "NONE" },
    Pmenu                    = { fg = "#C5CDD9", bg = "NONE" },
    CmpItemAbbrDeprecated    = { fg = "#7E8294", bg = "NONE", style = "strikethrough" },
    CmpItemAbbrMatchFuzzy    = { fg = "#82AAFF", bg = "NONE", style = "bold" },
    CmpItemMenu              = { fg = "#C792EA", bg = "NONE" },
    CmpItemKindField         = { fg = "#e06c75", bg = "NONE" },
    CmpItemKindIdentifier    = { fg = "#e06c75", bg = "NONE" },
    CmpItemKindEvent         = { fg = "#EED8DA", bg = "NONE" },
    CmpItemKindText          = { fg = "#98c379", bg = "NONE" },
    CmpItemKindEnum          = { fg = "#C3E88D", bg = "NONE" },
    CmpItemKindConstant      = { fg = "#d19a66", bg = "NONE" },
    CmpItemKindConstructor   = { fg = "#61afef", bg = "NONE" },
    CmpItemKindCopilot       = { fg = "#98c379", bg = "NONE" },
    CmpItemKindFunction      = { fg = "#61afef", bg = "NONE" },
    CmpItemKindClass         = { fg = "#EADFF0", bg = "NONE" },
    CmpItemKindModule        = { fg = "#e5c07b", bg = "NONE" },
    CmpItemKindType          = { fg = "#e5c07b", bg = "NONE" },
    CmpItemKindReference     = { fg = "#abb2bf", bg = "NONE" },
    CmpItemKindOperator      = { fg = "#abb2bf", bg = "NONE" },
    CmpItemKindVariable      = { fg = "#c678dd", bg = "NONE" },
    CmpItemKindStructure     = { fg = "#c678dd", bg = "NONE" },
    CmpItemKindStruct        = { fg = "#c678dd", bg = "NONE" },
    CmpItemKindUnit          = { fg = "#c678dd", bg = "NONE" },
    CmpItemKindSnippet       = { fg = "#e06c75", bg = "NONE" },
    CmpItemKindKeyword       = { fg = "#c8ccd4", bg = "NONE" },
    CmpItemKindFile          = { fg = "#c8ccd4", bg = "NONE" },
    CmpItemKindFolder        = { fg = "#c8ccd4", bg = "NONE" },
    CmpItemKindMethod        = { fg = "#61afef", bg = "NONE" },
    CmpItemKindValue         = { fg = "#DDE5F5", bg = "NONE" },
    CmpItemKindEnumMember    = { fg = "#DDE5F5", bg = "NONE" },
    CmpItemKindInterface     = { fg = "#D8EEEB", bg = "NONE" },
    CmpItemKindColor         = { fg = "#e06c75", bg = "NONE" },
    CmpItemKindProperty      = { fg = "#e06c75", bg = "NONE" },
    CmpItemKindTypeParameter = { fg = "#e06c75", bg = "NONE" },
}


local function highlight(group, color)
    local fg    = color.fg    and 'guifg=' .. color.fg    or 'guifg=NONE'
    local bg    = color.bg    and 'guibg=' .. color.bg    or 'guibg=NONE'
    local style = color.style and 'gui='   .. color.style or 'gui=NONE'
    local sp    = color.sp    and 'guisp=' .. color.sp    or ''

    vim.api.nvim_command(string.format(
        'highlight %s %s %s %s %s',
        group, fg, bg, style, sp
    ))
end

for group, color in pairs(telescope) do
    highlight(group, color)
end
for group, color in pairs(cmp) do
    highlight(group, color)
end