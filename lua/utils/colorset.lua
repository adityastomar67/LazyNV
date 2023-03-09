local COLOR = {}
local hex_re = vim.regex "#\\x\\x\\x\\x\\x\\x"

local HEX_DIGITS = {
  ["0"] = 0,
  ["1"] = 1,
  ["2"] = 2,
  ["3"] = 3,
  ["4"] = 4,
  ["5"] = 5,
  ["6"] = 6,
  ["7"] = 7,
  ["8"] = 8,
  ["9"] = 9,
  ["a"] = 10,
  ["b"] = 11,
  ["c"] = 12,
  ["d"] = 13,
  ["e"] = 14,
  ["f"] = 15,
  ["A"] = 10,
  ["B"] = 11,
  ["C"] = 12,
  ["D"] = 13,
  ["E"] = 14,
  ["F"] = 15,
}

local function hex_to_rgb(hex)
  return HEX_DIGITS[string.sub(hex, 1, 1)] * 16 + HEX_DIGITS[string.sub(hex, 2, 2)],
      HEX_DIGITS[string.sub(hex, 3, 3)] * 16 + HEX_DIGITS[string.sub(hex, 4, 4)],
      HEX_DIGITS[string.sub(hex, 5, 5)] * 16 + HEX_DIGITS[string.sub(hex, 6, 6)]
end

local function rgb_to_hex(r, g, b)
  return bit.tohex(bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b), 6)
end

local function darken(hex, pct)
  pct = 1 - pct
  local r, g, b = hex_to_rgb(string.sub(hex, 2))
  r = math.floor(r * pct)
  g = math.floor(g * pct)
  b = math.floor(b * pct)
  return string.format("#%s", rgb_to_hex(r, g, b))
end

COLOR.highlight = setmetatable({}, {
  __newindex = function(_, hlgroup, args)
    if "string" == type(args) then
      vim.cmd(("hi! link %s %s"):format(hlgroup, args))
      return
    end

    local guifg, guibg, gui, guisp = args.guifg or nil, args.guibg or nil, args.gui or nil, args.guisp or nil
    local cmd = { "hi", hlgroup }
    if guifg then table.insert(cmd, "guifg=" .. guifg) end
    if guibg then table.insert(cmd, "guibg=" .. guibg) end
    if gui   then table.insert(cmd, "gui=" .. gui)     end
    if guisp then table.insert(cmd, "guisp=" .. guisp) end
    vim.cmd(table.concat(cmd, " "))
  end,
})

function COLOR.with_config(config)
  COLOR.config = vim.tbl_extend("force", {
    telescope = true,
  }, config or COLOR.config or {})
end

function COLOR.setup(colors, config)
  COLOR.with_config(config)

  if type(colors) == "string" then
    colors = COLOR.colorschemes[colors]
  end

  if vim.fn.exists "syntax_on" then
    vim.cmd "syntax reset"
  end
  vim.cmd "set termguicolors"
  vim.cmd [[ highlight clear ]]

  COLOR.colors = colors or COLOR.colorschemes[vim.env.BASE16_THEME] or COLOR.colorschemes["schemer-dark"]
  local hi = COLOR.highlight
  
  -- Vim editor colors
  hi.Bold                               = { guifg = nil, guibg = nil, gui = "bold", guisp = nil }
  hi.Italic                             = { guifg = nil, guibg = nil, gui = "none", guisp = nil }
  hi.MatchParen                         = { guifg = nil, guibg = COLOR.colors.base03, gui = nil, guisp = nil }
  hi.Visual                             = { guifg = nil, guibg = COLOR.colors.base02, gui = nil, guisp = nil }
  hi.Debug                              = { guifg = COLOR.colors.base08, guibg = nil, gui = nil, guisp = nil }
  hi.Directory                          = { guifg = COLOR.colors.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.Exception                          = { guifg = COLOR.colors.base08, guibg = nil, gui = nil, guisp = nil }
  hi.Macro                              = { guifg = COLOR.colors.base08, guibg = nil, gui = nil, guisp = nil }
  hi.ModeMsg                            = { guifg = COLOR.colors.base0B, guibg = nil, gui = nil, guisp = nil }
  hi.MoreMsg                            = { guifg = COLOR.colors.base0B, guibg = nil, gui = nil, guisp = nil }
  hi.Question                           = { guifg = COLOR.colors.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.SpecialKey                         = { guifg = COLOR.colors.base03, guibg = nil, gui = nil, guisp = nil }
  hi.TooLong                            = { guifg = COLOR.colors.base08, guibg = nil, gui = nil, guisp = nil }
  hi.Underlined                         = { guifg = COLOR.colors.base08, guibg = nil, gui = nil, guisp = nil }
  hi.VisualNOS                          = { guifg = COLOR.colors.base08, guibg = nil, gui = nil, guisp = nil }
  hi.WarningMsg                         = { guifg = COLOR.colors.base08, guibg = nil, gui = nil, guisp = nil }
  hi.NonText                            = { guifg = COLOR.colors.base03, guibg = nil, gui = nil, guisp = nil }
  hi.ColorColumn                        = { guifg = nil, guibg = COLOR.colors.base01, gui = "none", guisp = nil }
  hi.CursorColumn                       = { guifg = nil, guibg = COLOR.colors.base01, gui = "none", guisp = nil }
  hi.CursorLine                         = { guifg = nil, guibg = COLOR.colors.base01, gui = "none", guisp = nil }
  hi.QuickFixLine                       = { guifg = nil, guibg = COLOR.colors.base01, gui = "none", guisp = nil }
  hi.Title                              = { guifg = COLOR.colors.base0D, guibg = nil, gui = "none", guisp = nil }
  hi.Normal                             = { guifg = COLOR.colors.base05, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.Error                              = { guifg = COLOR.colors.base00, guibg = COLOR.colors.base08, gui = nil, guisp = nil }
  hi.ErrorMsg                           = { guifg = COLOR.colors.base08, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.FoldColumn                         = { guifg = COLOR.colors.base0C, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.Folded                             = { guifg = COLOR.colors.base03, guibg = COLOR.colors.base01, gui = nil, guisp = nil }
  hi.Search                             = { guifg = COLOR.colors.base01, guibg = COLOR.colors.base0A, gui = nil, guisp = nil }
  hi.WildMenu                           = { guifg = COLOR.colors.base08, guibg = COLOR.colors.base0A, gui = nil, guisp = nil }
  hi.Conceal                            = { guifg = COLOR.colors.base0D, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.Cursor                             = { guifg = COLOR.colors.base00, guibg = COLOR.colors.base05, gui = nil, guisp = nil }
  hi.LineNr                             = { guifg = COLOR.colors.base04, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.SignColumn                         = { guifg = COLOR.colors.base04, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.CursorLineNr                       = { guifg = COLOR.colors.base04, guibg = COLOR.colors.base01, gui = nil, guisp = nil }
  hi.PMenuSel                           = { guifg = COLOR.colors.base01, guibg = COLOR.colors.base05, gui = nil, guisp = nil }
  hi.IncSearch                          = { guifg = COLOR.colors.base01, guibg = COLOR.colors.base09, gui = "none", guisp = nil }
  hi.Substitute                         = { guifg = COLOR.colors.base01, guibg = COLOR.colors.base0A, gui = "none", guisp = nil }
  hi.StatusLine                         = { guifg = COLOR.colors.base05, guibg = COLOR.colors.base02, gui = "none", guisp = nil }
  hi.StatusLineNC                       = { guifg = COLOR.colors.base04, guibg = COLOR.colors.base01, gui = "none", guisp = nil }
  hi.VertSplit                          = { guifg = COLOR.colors.base05, guibg = COLOR.colors.base00, gui = "none", guisp = nil }
  hi.PMenu                              = { guifg = COLOR.colors.base05, guibg = COLOR.colors.base01, gui = "none", guisp = nil }
  hi.TabLine                            = { guifg = COLOR.colors.base03, guibg = COLOR.colors.base01, gui = "none", guisp = nil }
  hi.TabLineFill                        = { guifg = COLOR.colors.base03, guibg = COLOR.colors.base01, gui = "none", guisp = nil }
  hi.TabLineSel                         = { guifg = COLOR.colors.base0B, guibg = COLOR.colors.base01, gui = "none", guisp = nil }
  
  -- Standard syntax highlighting
  hi.Boolean                            = { guifg = COLOR.colors.base09, guibg = nil, gui = nil, guisp = nil }
  hi.Character                          = { guifg = COLOR.colors.base08, guibg = nil, gui = nil, guisp = nil }
  hi.Comment                            = { guifg = COLOR.colors.base03, guibg = nil, gui = nil, guisp = nil }
  hi.Conditional                        = { guifg = COLOR.colors.base0E, guibg = nil, gui = nil, guisp = nil }
  hi.Constant                           = { guifg = COLOR.colors.base09, guibg = nil, gui = nil, guisp = nil }
  hi.Delimiter                          = { guifg = COLOR.colors.base0F, guibg = nil, gui = nil, guisp = nil }
  hi.Float                              = { guifg = COLOR.colors.base09, guibg = nil, gui = nil, guisp = nil }
  hi.Function                           = { guifg = COLOR.colors.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.Include                            = { guifg = COLOR.colors.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.Keyword                            = { guifg = COLOR.colors.base0E, guibg = nil, gui = nil, guisp = nil }
  hi.Label                              = { guifg = COLOR.colors.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.Number                             = { guifg = COLOR.colors.base09, guibg = nil, gui = nil, guisp = nil }
  hi.PreProc                            = { guifg = COLOR.colors.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.Repeat                             = { guifg = COLOR.colors.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.Special                            = { guifg = COLOR.colors.base0C, guibg = nil, gui = nil, guisp = nil }
  hi.SpecialChar                        = { guifg = COLOR.colors.base0F, guibg = nil, gui = nil, guisp = nil }
  hi.Statement                          = { guifg = COLOR.colors.base08, guibg = nil, gui = nil, guisp = nil }
  hi.StorageClass                       = { guifg = COLOR.colors.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.String                             = { guifg = COLOR.colors.base0B, guibg = nil, gui = nil, guisp = nil }
  hi.Structure                          = { guifg = COLOR.colors.base0E, guibg = nil, gui = nil, guisp = nil }
  hi.Tag                                = { guifg = COLOR.colors.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.Typedef                            = { guifg = COLOR.colors.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.Identifier                         = { guifg = COLOR.colors.base08, guibg = nil, gui = "none", guisp = nil }
  hi.Define                             = { guifg = COLOR.colors.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.Operator                           = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.Type                               = { guifg = COLOR.colors.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.Todo                               = { guifg = COLOR.colors.base0A, guibg = COLOR.colors.base01, gui = nil, guisp = nil }

  -- Diff highlighting
  hi.DiffAdd                            = { guifg = COLOR.colors.base0B, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.DiffChange                         = { guifg = COLOR.colors.base03, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.DiffDelete                         = { guifg = COLOR.colors.base08, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.DiffText                           = { guifg = COLOR.colors.base0D, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.DiffAdded                          = { guifg = COLOR.colors.base0B, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.DiffFile                           = { guifg = COLOR.colors.base08, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.DiffNewFile                        = { guifg = COLOR.colors.base0B, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.DiffLine                           = { guifg = COLOR.colors.base0D, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.DiffRemoved                        = { guifg = COLOR.colors.base08, guibg = COLOR.colors.base00, gui = nil, guisp = nil }

  -- Git highlighting
  hi.gitcommitOverflow                  = { guifg = COLOR.colors.base08, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitSummary                   = { guifg = COLOR.colors.base0B, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitComment                   = { guifg = COLOR.colors.base03, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitUntracked                 = { guifg = COLOR.colors.base03, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitDiscarded                 = { guifg = COLOR.colors.base03, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitSelected                  = { guifg = COLOR.colors.base03, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitHeader                    = { guifg = COLOR.colors.base0E, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitSelectedType              = { guifg = COLOR.colors.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitUnmergedType              = { guifg = COLOR.colors.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitDiscardedType             = { guifg = COLOR.colors.base0D, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitUntrackedFile             = { guifg = COLOR.colors.base0A, guibg = nil, gui = nil, guisp = nil }
  hi.gitcommitBranch                    = { guifg = COLOR.colors.base09, guibg = nil, gui = "bold", guisp = nil }
  hi.gitcommitUnmergedFile              = { guifg = COLOR.colors.base08, guibg = nil, gui = "bold", guisp = nil }
  hi.gitcommitDiscardedFile             = { guifg = COLOR.colors.base08, guibg = nil, gui = "bold", guisp = nil }
  hi.gitcommitSelectedFile              = { guifg = COLOR.colors.base0B, guibg = nil, gui = "bold", guisp = nil }

  -- GitGutter highlighting
  hi.GitGutterAdd                       = { guifg = COLOR.colors.base0B, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.GitGutterChange                    = { guifg = COLOR.colors.base0D, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.GitGutterDelete                    = { guifg = COLOR.colors.base08, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.GitGutterChangeDelete              = { guifg = COLOR.colors.base0E, guibg = COLOR.colors.base00, gui = nil, guisp = nil }

  -- Spelling highlighting
  hi.SpellBad                           = { guifg = nil, guibg = nil, gui = "undercurl", guisp = COLOR.colors.base08 }
  hi.SpellLocal                         = { guifg = nil, guibg = nil, gui = "undercurl", guisp = COLOR.colors.base0C }
  hi.SpellCap                           = { guifg = nil, guibg = nil, gui = "undercurl", guisp = COLOR.colors.base0D }
  hi.SpellRare                          = { guifg = nil, guibg = nil, gui = "undercurl", guisp = COLOR.colors.base0E }

  hi.DiagnosticError                    = { guifg = COLOR.colors.base08, guibg = nil, gui = "none", guisp = nil }
  hi.DiagnosticWarn                     = { guifg = COLOR.colors.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.DiagnosticInfo                     = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.DiagnosticHint                     = { guifg = COLOR.colors.base0C, guibg = nil, gui = "none", guisp = nil }
  hi.DiagnosticUnderlineError           = { guifg = nil, guibg = nil, gui = "undercurl", guisp = COLOR.colors.base08 }
  hi.DiagnosticUnderlineWarning         = { guifg = nil, guibg = nil, gui = "undercurl", guisp = COLOR.colors.base0E }
  hi.DiagnosticUnderlineWarn            = { guifg = nil, guibg = nil, gui = "undercurl", guisp = COLOR.colors.base0E }
  hi.DiagnosticUnderlineInformation     = { guifg = nil, guibg = nil, gui = "undercurl", guisp = COLOR.colors.base0F }
  hi.DiagnosticUnderlineHint            = { guifg = nil, guibg = nil, gui = "undercurl", guisp = COLOR.colors.base0C }

  hi.LspReferenceText                   = { guifg = nil, guibg = nil, gui = "underline", guisp = COLOR.colors.base04 }
  hi.LspReferenceRead                   = { guifg = nil, guibg = nil, gui = "underline", guisp = COLOR.colors.base04 }
  hi.LspReferenceWrite                  = { guifg = nil, guibg = nil, gui = "underline", guisp = COLOR.colors.base04 }
  hi.LspDiagnosticsDefaultError         = "DiagnosticError"
  hi.LspDiagnosticsDefaultWarning       = "DiagnosticWarn"
  hi.LspDiagnosticsDefaultInformation   = "DiagnosticInfo"
  hi.LspDiagnosticsDefaultHint          = "DiagnosticHint"
  hi.LspDiagnosticsUnderlineError       = "DiagnosticUnderlineError"
  hi.LspDiagnosticsUnderlineWarning     = "DiagnosticUnderlineWarning"
  hi.LspDiagnosticsUnderlineInformation = "DiagnosticUnderlineInformation"
  hi.LspDiagnosticsUnderlineHint        = "DiagnosticUnderlineHint"
  
  hi.TSCurrentScope                     = { guifg = nil, guibg = nil, gui = "bold", guisp = nil }
  hi.TSStrong                           = { guifg = nil, guibg = nil, gui = "bold", guisp = nil }
  hi.TSAnnotation                       = { guifg = COLOR.colors.base0F, guibg = nil, gui = "none", guisp = nil }
  hi.TSAttribute                        = { guifg = COLOR.colors.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.TSBoolean                          = { guifg = COLOR.colors.base09, guibg = nil, gui = "none", guisp = nil }
  hi.TSCharacter                        = { guifg = COLOR.colors.base08, guibg = nil, gui = "none", guisp = nil }
  hi.TSConstructor                      = { guifg = COLOR.colors.base0D, guibg = nil, gui = "none", guisp = nil }
  hi.TSConditional                      = { guifg = COLOR.colors.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.TSConstant                         = { guifg = COLOR.colors.base09, guibg = nil, gui = "none", guisp = nil }
  hi.TSConstMacro                       = { guifg = COLOR.colors.base08, guibg = nil, gui = "none", guisp = nil }
  hi.TSError                            = { guifg = COLOR.colors.base08, guibg = nil, gui = "none", guisp = nil }
  hi.TSException                        = { guifg = COLOR.colors.base08, guibg = nil, gui = "none", guisp = nil }
  hi.TSField                            = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSFloat                            = { guifg = COLOR.colors.base09, guibg = nil, gui = "none", guisp = nil }
  hi.TSFunction                         = { guifg = COLOR.colors.base0D, guibg = nil, gui = "none", guisp = nil }
  hi.TSFuncMacro                        = { guifg = COLOR.colors.base08, guibg = nil, gui = "none", guisp = nil }
  hi.TSInclude                          = { guifg = COLOR.colors.base0D, guibg = nil, gui = "none", guisp = nil }
  hi.TSKeyword                          = { guifg = COLOR.colors.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.TSKeywordFunction                  = { guifg = COLOR.colors.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.TSKeywordOperator                  = { guifg = COLOR.colors.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.TSLabel                            = { guifg = COLOR.colors.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.TSMethod                           = { guifg = COLOR.colors.base0D, guibg = nil, gui = "none", guisp = nil }
  hi.TSNamespace                        = { guifg = COLOR.colors.base08, guibg = nil, gui = "none", guisp = nil }
  hi.TSNone                             = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSNumber                           = { guifg = COLOR.colors.base09, guibg = nil, gui = "none", guisp = nil }
  hi.TSOperator                         = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSParameter                        = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSParameterReference               = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSProperty                         = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSPunctDelimiter                   = { guifg = COLOR.colors.base0F, guibg = nil, gui = "none", guisp = nil }
  hi.TSPunctBracket                     = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSPunctSpecial                     = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSRepeat                           = { guifg = COLOR.colors.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.TSString                           = { guifg = COLOR.colors.base0B, guibg = nil, gui = "none", guisp = nil }
  hi.TSStringRegex                      = { guifg = COLOR.colors.base0C, guibg = nil, gui = "none", guisp = nil }
  hi.TSStringEscape                     = { guifg = COLOR.colors.base0C, guibg = nil, gui = "none", guisp = nil }
  hi.TSSymbol                           = { guifg = COLOR.colors.base0B, guibg = nil, gui = "none", guisp = nil }
  hi.TSTag                              = { guifg = COLOR.colors.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.TSTagDelimiter                     = { guifg = COLOR.colors.base0F, guibg = nil, gui = "none", guisp = nil }
  hi.TSText                             = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.TSTitle                            = { guifg = COLOR.colors.base0D, guibg = nil, gui = "none", guisp = nil }
  hi.TSLiteral                          = { guifg = COLOR.colors.base09, guibg = nil, gui = "none", guisp = nil }
  hi.TSType                             = { guifg = COLOR.colors.base0A, guibg = nil, gui = "none", guisp = nil }
  hi.TSVariable                         = { guifg = COLOR.colors.base08, guibg = nil, gui = "none", guisp = nil }
  hi.TSComment                          = { guifg = COLOR.colors.base03, guibg = nil, gui = "italic", guisp = nil }
  hi.TSConstBuiltin                     = { guifg = COLOR.colors.base09, guibg = nil, gui = "italic", guisp = nil }
  hi.TSFuncBuiltin                      = { guifg = COLOR.colors.base0D, guibg = nil, gui = "italic", guisp = nil }
  hi.TSEmphasis                         = { guifg = COLOR.colors.base09, guibg = nil, gui = "italic", guisp = nil }
  hi.TSTypeBuiltin                      = { guifg = COLOR.colors.base0A, guibg = nil, gui = "italic", guisp = nil }
  hi.TSVariableBuiltin                  = { guifg = COLOR.colors.base08, guibg = nil, gui = "italic", guisp = nil }
  hi.TSUnderline                        = { guifg = COLOR.colors.base00, guibg = nil, gui = "underline", guisp = nil }
  hi.TSURI                              = { guifg = COLOR.colors.base09, guibg = nil, gui = "underline", guisp = nil }
  hi.TSDefinition                       = { guifg = nil, guibg = nil, gui = "underline", guisp = COLOR.colors.base04 }
  hi.TSDefinitionUsage                  = { guifg = nil, guibg = nil, gui = "underline", guisp = COLOR.colors.base04 }
  hi.TSStrike                           = { guifg = COLOR.colors.base00, guibg = nil, gui = "strikethrough", guisp = nil }

  hi.NvimInternalError                  = { guifg = COLOR.colors.base00, guibg = COLOR.colors.base08, gui = "none", guisp = nil }

  hi.NormalFloat                        = { guifg = COLOR.colors.base05, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.FloatBorder                        = { guifg = COLOR.colors.base05, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.NormalNC                           = { guifg = COLOR.colors.base05, guibg = COLOR.colors.base00, gui = nil, guisp = nil }
  hi.TermCursorNC                       = { guifg = COLOR.colors.base00, guibg = COLOR.colors.base05, gui = nil, guisp = nil }
  hi.TermCursor                         = { guifg = COLOR.colors.base00, guibg = COLOR.colors.base05, gui = "none", guisp = nil }

  hi.User1                              = { guifg = COLOR.colors.base08, guibg = COLOR.colors.base02, gui = "none", guisp = nil }
  hi.User2                              = { guifg = COLOR.colors.base0E, guibg = COLOR.colors.base02, gui = "none", guisp = nil }
  hi.User3                              = { guifg = COLOR.colors.base05, guibg = COLOR.colors.base02, gui = "none", guisp = nil }
  hi.User4                              = { guifg = COLOR.colors.base0C, guibg = COLOR.colors.base02, gui = "none", guisp = nil }
  hi.User5                              = { guifg = COLOR.colors.base01, guibg = COLOR.colors.base02, gui = "none", guisp = nil }
  hi.User6                              = { guifg = COLOR.colors.base05, guibg = COLOR.colors.base02, gui = "none", guisp = nil }
  hi.User7                              = { guifg = COLOR.colors.base05, guibg = COLOR.colors.base02, gui = "none", guisp = nil }
  hi.User8                              = { guifg = COLOR.colors.base00, guibg = COLOR.colors.base02, gui = "none", guisp = nil }
  hi.User9                              = { guifg = COLOR.colors.base00, guibg = COLOR.colors.base02, gui = "none", guisp = nil }

  hi.TreesitterContext                  = { guifg = nil, guibg = COLOR.colors.base01, gui = "italic", guisp = nil }

  if COLOR.config.telescope then
    if
        hex_re:match_str(COLOR.colors.base00) and hex_re:match_str(COLOR.colors.base01) and hex_re:match_str(COLOR.colors.base02)
    then
      local darkerbg           = darken(COLOR.colors.base00, 0.1)
      local darkercursorline   = darken(COLOR.colors.base01, 0.1)
      local darkerstatusline   = darken(COLOR.colors.base02, 0.1)
      hi.TelescopeNormal       = { guifg = nil,                 guibg = darkerbg,            gui = nil, guisp = nil }
      hi.TelescopeSelection    = { guifg = nil,                 guibg = darkerstatusline,    gui = nil, guisp = nil }
      hi.TelescopeBorder       = { guifg = darkerbg,            guibg = darkerbg,            gui = nil, guisp = nil }
      hi.TelescopePromptBorder = { guifg = darkerstatusline,    guibg = darkerstatusline,    gui = nil, guisp = nil }
      hi.TelescopePromptNormal = { guifg = COLOR.colors.base05, guibg = darkerstatusline,    gui = nil, guisp = nil }
      hi.TelescopePromptPrefix = { guifg = COLOR.colors.base08, guibg = darkerstatusline,    gui = nil, guisp = nil }
      hi.TelescopePreviewTitle = { guifg = darkercursorline,    guibg = COLOR.colors.base0B, gui = nil, guisp = nil }
      hi.TelescopePromptTitle  = { guifg = darkercursorline,    guibg = COLOR.colors.base08, gui = nil, guisp = nil }
      hi.TelescopeResultsTitle = { guifg = darkerbg,            guibg = darkerbg,            gui = nil, guisp = nil }
    end
  end

  hi.NotifyERRORBorder    = { guifg = COLOR.colors.base08, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyWARNBorder     = { guifg = COLOR.colors.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyINFOBorder     = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyDEBUGBorder    = { guifg = COLOR.colors.base0C, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyTRACEBorder    = { guifg = COLOR.colors.base0C, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyERRORIcon      = { guifg = COLOR.colors.base08, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyWARNIcon       = { guifg = COLOR.colors.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyINFOIcon       = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyDEBUGIcon      = { guifg = COLOR.colors.base0C, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyTRACEIcon      = { guifg = COLOR.colors.base0C, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyERRORTitle     = { guifg = COLOR.colors.base08, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyWARNTitle      = { guifg = COLOR.colors.base0E, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyINFOTitle      = { guifg = COLOR.colors.base05, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyDEBUGTitle     = { guifg = COLOR.colors.base0C, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyTRACETitle     = { guifg = COLOR.colors.base0C, guibg = nil, gui = "none", guisp = nil }
  hi.NotifyERRORBody      = "Normal"
  hi.NotifyWARNBody       = "Normal"
  hi.NotifyINFOBody       = "Normal"
  hi.NotifyDEBUGBody      = "Normal"
  hi.NotifyTRACEBody      = "Normal"

  vim.g.terminal_color_0  = COLOR.colors.base00
  vim.g.terminal_color_1  = COLOR.colors.base08
  vim.g.terminal_color_2  = COLOR.colors.base0B
  vim.g.terminal_color_3  = COLOR.colors.base0A
  vim.g.terminal_color_4  = COLOR.colors.base0D
  vim.g.terminal_color_5  = COLOR.colors.base0E
  vim.g.terminal_color_6  = COLOR.colors.base0C
  vim.g.terminal_color_7  = COLOR.colors.base05
  vim.g.terminal_color_8  = COLOR.colors.base03
  vim.g.terminal_color_9  = COLOR.colors.base08
  vim.g.terminal_color_10 = COLOR.colors.base0B
  vim.g.terminal_color_11 = COLOR.colors.base0A
  vim.g.terminal_color_12 = COLOR.colors.base0D
  vim.g.terminal_color_13 = COLOR.colors.base0E
  vim.g.terminal_color_14 = COLOR.colors.base0C
  vim.g.terminal_color_15 = COLOR.colors.base07
end

function COLOR.available_colorschemes()
  return vim.tbl_keys(COLOR.colorschemes)
end

COLOR.colorschemes = {}
setmetatable(COLOR.colorschemes, {
  __index = function(t, key)
    t[key] = require(string.format("colors.%s", key))
    return t[key]
  end,
})

-- #16161D is called eigengrau and is kinda-ish the color your see when you
-- close your eyes. It makes for a really good background.
COLOR.colorschemes["schemer-dark"] = {
  base00 = "#16161D",
  base01 = "#3e4451",
  base02 = "#2c313c",
  base03 = "#565c64",
  base04 = "#6c7891",
  base05 = "#abb2bf",
  base06 = "#9a9bb3",
  base07 = "#c5c8e6",
  base08 = "#e06c75",
  base09 = "#d19a66",
  base0A = "#e5c07b",
  base0B = "#98c379",
  base0C = "#56b6c2",
  base0D = "#0184bc",
  base0E = "#c678dd",
  base0F = "#a06949",
}
COLOR.colorschemes["schemer-medium"] = {
  base00 = "#212226",
  base01 = "#3e4451",
  base02 = "#2c313c",
  base03 = "#565c64",
  base04 = "#6c7891",
  base05 = "#abb2bf",
  base06 = "#9a9bb3",
  base07 = "#c5c8e6",
  base08 = "#e06c75",
  base09 = "#d19a66",
  base0A = "#e5c07b",
  base0B = "#98c379",
  base0C = "#56b6c2",
  base0D = "#0184bc",
  base0E = "#c678dd",
  base0F = "#a06949",
}

return COLOR
