local alpha = 0.4
local blend = require("utils.colorset").blend

local base16 = {
    base00 = "#1e222a",
    base01 = "#353b45",
    base02 = "#3e4451",
    base03 = "#545862",
    base04 = "#565c64",
    base05 = "#abb2bf",
    base06 = "#b6bdca",
    base07 = "#c8ccd4",
    base08 = "#e06c75",
    base09 = "#d19a66",
    base0A = "#e5c07b",
    base0B = "#98c379",
    base0C = "#56b6c2",
    base0D = "#61afef",
    base0E = "#c678dd",
    base0F = "#be5046",
}
local colors = {
    white         = "#abb2bf",
    darker_black  = "#1b1f27",
    black         = "#1e222a", --  nvim bg
    black2        = "#252931",
    one_bg        = "#282c34", -- real bg of onedark
    one_bg2       = "#353b45",
    one_bg3       = "#373b43",
    grey          = "#42464e",
    grey_fg       = "#565c64",
    grey_fg2      = "#6f737b",
    light_grey    = "#6f737b",
    red           = "#e06c75",
    baby_pink     = "#DE8C92",
    pink          = "#ff75a0",
    line          = "#31353d", -- for lines like vertsplit
    green         = "#98c379",
    vibrant_green = "#7eca9c",
    nord_blue     = "#81A1C1",
    blue          = "#61afef",
    yellow        = "#e7c787",
    sun           = "#EBCB8B",
    purple        = "#de98fd",
    dark_purple   = "#c882e7",
    teal          = "#519ABA",
    orange        = "#fca2aa",
    cyan          = "#a3b8ef",
    statusline_bg = "#22262e",
    lightbg       = "#2d3139",
    pmenu_bg      = "#61afef",
    folder_bg     = "#61afef",
}

local highlights = {
    CmpItemAbbr      = { fg = colors.white },
    CmpItemAbbrMatch = { fg = colors.blue, style = "bold" },
    CmpDocBorder     = { fg = colors.darker_black, bg = colors.darker_black },
    CmpPmenu         = { bg = colors.black },
    CmpSel           = { link = "PmenuSel", style = "bold" },
}

local item_kinds = {
    -- cmp item kinds
    CmpItemKindConstant      = { fg = base16.base09 },
    CmpItemKindFunction      = { fg = base16.base0D },
    CmpItemKindIdentifier    = { fg = base16.base08 },
    CmpItemKindField         = { fg = base16.base08 },
    CmpItemKindVariable      = { fg = base16.base0E },
    CmpItemKindSnippet       = { fg = colors.red },
    CmpItemKindText          = { fg = base16.base0B },
    CmpItemKindStructure     = { fg = base16.base0E },
    CmpItemKindType          = { fg = base16.base0A },
    CmpItemKindKeyword       = { fg = base16.base07 },
    CmpItemKindMethod        = { fg = base16.base0D },
    CmpItemKindConstructor   = { fg = colors.blue },
    CmpItemKindFolder        = { fg = base16.base07 },
    CmpItemKindModule        = { fg = base16.base0A },
    CmpItemKindProperty      = { fg = base16.base08 },
    CmpItemKindEnum          = { fg = colors.blue },
    CmpItemKindUnit          = { fg = base16.base0E },
    CmpItemKindClass         = { fg = colors.teal },
    CmpItemKindFile          = { fg = base16.base07 },
    CmpItemKindInterface     = { fg = colors.green },
    CmpItemKindColor         = { fg = colors.white },
    CmpItemKindReference     = { fg = base16.base05 },
    CmpItemKindEnumMember    = { fg = colors.purple },
    CmpItemKindStruct        = { fg = base16.base0E },
    CmpItemKindValue         = { fg = colors.cyan },
    CmpItemKindEvent         = { fg = colors.yellow },
    CmpItemKindOperator      = { fg = base16.base05 },
    CmpItemKindTypeParameter = { fg = base16.base08 },
    CmpItemKindCopilot       = { fg = colors.green },
}

local cmp_ui = require("config.user").plugin_configs.cmp

-- custom highlights per style!
local styles = {
    default = {
        CmpBorder = { fg = colors[cmp_ui.border_color] },
    },
    atom = {
        CmpItemMenu = { fg = colors.light_grey, style = "italic" },
        CmpPmenu = {
            bg = colors.black2,
        },
        CmpDoc = { bg = colors.darker_black },
        CmpDocBorder = { fg = colors.darker_black, bg = colors.darker_black },
    },
    atom_colored = {
        CmpItemMenu = { fg = colors.light_grey, style = "italic" },
        CmpPmenu = {
            bg = colors.black2,
        },
        CmpDoc = { bg = blend(colors.darker_black, "#001b1f27", alpha) },
        CmpDocBorder = { fg = blend(colors.darker_black, "#001b1f27", alpha),
            bg = blend(colors.darker_black, "#001b1f27", alpha) },
    },
    flat_light = {
        CmpPmenu = {
            bg = colors.black2,
        },
        CmpBorder = { fg = colors.black2, bg = colors.black2 },
        CmpDocBorder = { fg = colors.darker_black, bg = colors.darker_black },
    },
    flat_dark = {
        CmpPmenu = {
            bg = colors.darker_black,
        },
        CmpBorder = { fg = colors.darker_black, bg = colors.darker_black },
        CmpDocBorder = { fg = colors.black2, bg = colors.black2 },
        CmpDoc = { bg = colors.black2 },
    },
}

local generate_color = require("utils.colorset").change_hex_lightness

-- override item_kind highlights for atom style
if cmp_ui.style == "atom" then
    for key, value in pairs(item_kinds) do
        item_kinds[key] = vim.tbl_deep_extend(
            "force",
            value,
            { bg = vim.o.bg == "dark" and generate_color(colors.black2, 6) or generate_color(colors.black2, -6) }
        )
    end
end

-- override item_kind highlights for atom_colored style
if cmp_ui.style == "atom_colored" then
    for key, value in pairs(item_kinds) do
        item_kinds[key] = { fg = colors.black, bg = generate_color(value.fg, -3), style = "bold" }
    end
end

highlights = vim.tbl_deep_extend("force", highlights, styles[cmp_ui.style] or {})
highlights = vim.tbl_deep_extend("force", highlights, item_kinds)

if cmp_ui.selected_item_bg == "simple" then
    highlights.CmpSel =
    { fg = colors.white, bg = (highlights.CmpPmenu.bg == colors.black2 and colors.grey or colors.one_bg3), style = "bold" }
end

local function apply()
    local async
    async = vim.loop.new_async(
        vim.schedule_wrap(
            function()
                for group, color in pairs(highlights) do
                    local fg = color.fg and 'guifg=' .. color.fg or 'guifg=NONE'
                    local bg = color.bg and 'guibg=' .. color.bg or 'guibg=NONE'
                    local style = color.style and 'gui=' .. color.style or 'gui=NONE'
                    vim.api.nvim_command(string.format(
                        'highlight %s %s %s %s',
                        group, fg, bg, style
                    ))
                end
                async:close()
            end
        )
    )
    async:send()
end


return apply()
