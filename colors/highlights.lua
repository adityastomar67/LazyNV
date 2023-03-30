local alpha = 0.4
local blend = require("utils.colorset").blend
local set_hl = vim.api.nvim_set_hl

-- Data for limelight_conceal
if require("utils").has("limelight") then
    vim.cmd [[let g:limelight_conceal_ctermfg = 'gray']]
    vim.cmd [[let g:limelight_conceal_ctermfg = 240]]
    vim.cmd [[let g:limelight_conceal_guifg = 'DarkGray']]
    vim.cmd [[let g:limelight_conceal_guifg = '#777777']]
    vim.cmd [[let g:limelight_default_coefficient = 0.9]]
end

local Theme = function()
    local gitsigns = {
        GitSignsAdd      = { fg = '#91b362', bg = "NONE" },
        GitSignsAddNr    = { fg = '#91b362', bg = "NONE" },
        GitSignsAddLn    = { fg = '#91b362', bg = "NONE" },
        GitSignsChange   = { fg = '#6994bf', bg = "NONE" },
        GitSignsChangeNr = { fg = '#6994bf', bg = "NONE" },
        GitSignsChangeLn = { fg = '#6994bf', bg = "NONE" },
        GitSignsDelete   = { fg = '#d96c75', bg = "NONE" },
        GitSignsDeleteNr = { fg = '#d96c75', bg = "NONE" },
        GitSignsDeleteLn = { fg = '#d96c75', bg = "NONE" },
    }
    return vim.tbl_extend('error',
        gitsigns
    )
end

local function highlight(group, color)
    local fg    = color.fg and 'guifg=' .. color.fg or 'guifg=NONE'
    local bg    = color.bg and 'guibg=' .. color.bg or 'guibg=NONE'
    local style = color.style and 'gui=' .. color.style or 'gui=NONE'
    local sp    = color.sp and 'guisp=' .. color.sp or ''

    vim.api.nvim_command(string.format(
        'highlight %s %s %s %s %s',
        group, fg, bg, style, sp
    ))
end

local function apply()
    local async
    async = vim.loop.new_async(
        vim.schedule_wrap(
            function()
                for group, color in pairs(Theme()) do
                    highlight(group, color)
                end
                set_hl(0, "DiagnosticVirtualTextError", { bg = "NONE", fg = blend("#db4b4b", "#00db4b4b", alpha) })
                set_hl(0, "DiagnosticVirtualTextWarn" , { bg = "NONE", fg = blend("#e0af68", "#00e0af68", alpha) })
                set_hl(0, "DiagnosticVirtualTextInfo" , { bg = "NONE", fg = blend("#0db9d7", "#000db9d7", alpha) })
                set_hl(0, "DiagnosticVirtualTextHint" , { bg = "NONE", fg = blend("#10B981", "#0010B981", alpha) })
                set_hl(0, "MsgSeparator"              , { bg = "NONE", fg = "NONE" })
                vim.cmd [[colorscheme telescope]]
                vim.cmd [[colorscheme cmp]]
                async:close()
            end
        )
    )
    async:send()
end

return apply()
