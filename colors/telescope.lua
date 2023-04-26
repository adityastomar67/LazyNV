local colors = {
    white = "#abb2bf",
    darker_black = "#1b1f27",
    black = "#1e222a",  --  nvim bg
    black2 = "#252931",
    one_bg = "#282c34", -- real bg of onedark
    one_bg2 = "#353b45",
    one_bg3 = "#373b43",
    grey = "#42464e",
    grey_fg = "#565c64",
    grey_fg2 = "#6f737b",
    light_grey = "#6f737b",
    red = "#e06c75",
    baby_pink = "#DE8C92",
    pink = "#ff75a0",
    line = "#31353d", -- for lines like vertsplit
    green = "#98c379",
    vibrant_green = "#7eca9c",
    nord_blue = "#81A1C1",
    blue = "#61afef",
    yellow = "#e7c787",
    sun = "#EBCB8B",
    purple = "#de98fd",
    dark_purple = "#c882e7",
    teal = "#519ABA",
    orange = "#fca2aa",
    cyan = "#a3b8ef",
    statusline_bg = "#22262e",
    lightbg = "#2d3139",
    pmenu_bg = "#61afef",
    folder_bg = "#61afef",
}

local telescope_style = "borderless"

local hlgroups = {
    TelescopePromptPrefix = {
        fg = colors.red,
        bg = colors.black2,
    },
    TelescopeNormal = { bg = colors.darker_black },
    TelescopePreviewTitle = {
        fg = colors.black,
        bg = colors.green,
    },
    TelescopePromptTitle = {
        fg = colors.black,
        bg = colors.red,
    },
    TelescopeSelection = { bg = colors.black2, fg = colors.white },
    TelescopeResultsDiffAdd = { fg = colors.green },
    TelescopeResultsDiffChange = { fg = colors.yellow },
    TelescopeResultsDiffDelete = { fg = colors.red },
}

local styles = {
    borderless = {
        TelescopeBorder = { fg = colors.darker_black, bg = colors.darker_black },
        TelescopePreviewBorder = { fg = colors.darker_black, bg = colors.darker_black },
        TelescopeResultsBorder = { fg = colors.darker_black, bg = colors.darker_black },
        TelescopePromptBorder  = { fg = colors.black2, bg = colors.black2 },
        TelescopePromptNormal = { fg = colors.white, bg = colors.black2 },
        TelescopeResultsTitle = { fg = colors.darker_black, bg = colors.darker_black },
        TelescopePromptPrefix = { fg = colors.red, bg = colors.black2 },
    },
    bordered = {
        TelescopeBorder = { fg = colors.one_bg3 },
        TelescopePromptBorder = { fg = colors.one_bg3 },
        TelescopeResultsTitle = { fg = colors.black, bg = colors.green },
        TelescopePreviewTitle = { fg = colors.black, bg = colors.blue },
        TelescopePromptPrefix = { fg = colors.red, bg = colors.black },
        TelescopeNormal = { bg = colors.black },
        TelescopePromptNormal = { bg = colors.black },
    },
}

local result = vim.tbl_deep_extend("force", hlgroups, styles[telescope_style])

local function apply()
    local async
    async = vim.loop.new_async(
        vim.schedule_wrap(
            function()
                for group, color in pairs(result) do
                    local fg = color.fg and 'guifg=' .. color.fg or 'guifg=NONE'
                    local bg = color.bg and 'guibg=' .. color.bg or 'guibg=NONE'
                    vim.api.nvim_command(string.format(
                        'highlight %s %s %s',
                        group, fg, bg
                    ))
                end
                async:close()
            end
        )
    )
    async:send()
end


return apply()
