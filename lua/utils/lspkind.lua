local lspkind = {}
local fmt = string.format

lspkind.icons = {
    kind = {
        Array = "",
        Boolean = "",
        Class = "",
        Color = "",
        Constant = "",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "",
        File = "",
        Folder = "",
        Function = "",
        Interface = "",
        Key = "",
        Keyword = "",
        Method = "",
        Module = "",
        Namespace = "",
        Null = "ﳠ",
        Number = "",
        Object = "",
        Operator = "",
        Package = "",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "",
        Struct = "",
        Text = "",
        TypeParameter = "",
        Unit = "",
        Value = "",
        Variable = "",
    },
    git = {
        LineAdded = "",
        LineModified = "",
        LineRemoved = "",
        FileDeleted = "",
        FileIgnored = "◌",
        FileRenamed = "",
        FileStaged = "S",
        FileUnmerged = "",
        FileUnstaged = "",
        FileUntracked = "U",
        Diff = "",
        Repo = "",
        Octoface = "",
        Branch = "",
    },
    ui = {
        ArrowCircleDown = "",
        ArrowCircleLeft = "",
        ArrowCircleRight = "",
        ArrowCircleUp = "",
        BoldArrowDown = "",
        BoldArrowLeft = "",
        BoldArrowRight = "",
        BoldArrowUp = "",
        BoldClose = "",
        BoldDividerLeft = "",
        BoldDividerRight = "",
        BoldLineLeft = "▎",
        BookMark = "",
        BoxChecked = "",
        Bug = "",
        Stacks = "",
        Scopes = "",
        Watches = "",
        DebugConsole = "",
        Calendar = "",
        Check = "",
        ChevronRight = ">",
        ChevronShortDown = "",
        ChevronShortLeft = "",
        ChevronShortRight = "",
        ChevronShortUp = "",
        Circle = "",
        Close = "",
        CloudDownload = "",
        Code = "",
        Comment = "",
        Dashboard = "",
        DividerLeft = "",
        DividerRight = "",
        DoubleChevronRight = "»",
        Ellipsis = "",
        EmptyFolder = "",
        EmptyFolderOpen = "",
        File = "",
        FileSymlink = "",
        Files = "",
        FindFile = "",
        FindText = "",
        Fire = "",
        Folder = "",
        FolderOpen = "",
        FolderSymlink = "",
        Forward = "",
        Gear = "",
        History = "",
        Lightbulb = "",
        LineLeft = "▏",
        LineMiddle = "│",
        List = "",
        Lock = "",
        NewFile = "",
        Note = "",
        Package = "",
        Pencil = "",
        Plus = "",
        Project = "",
        Search = "  ",
        SignIn = "",
        SignOut = "",
        Tab = "",
        Table = "",
        Target = "",
        Telescope = "",
        Text = "",
        Tree = "",
        Triangle = "契",
        TriangleShortArrowDown = "",
        TriangleShortArrowLeft = "",
        TriangleShortArrowRight = "",
        TriangleShortArrowUp = "",
    },
    diagnostics = {
        BoldError = "",
        Error = "",
        BoldWarning = "",
        Warning = "",
        BoldInformation = "",
        Information = "",
        BoldQuestion = "",
        Question = "",
        BoldHint = "",
        Hint = "",
        Debug = "",
        Trace = "✎",
    },
    misc = {
        Robot = "ﮧ",
        Squirrel = "",
        Tag = "",
        Watch = "",
        Smiley = "",
        Package = "",
        CircuitBoard = "",
    },
}

local kind_presets = {
    default = {
        Copilot       = "",
        Tabnine       = "",
        Class         = "",
        Text          = "",
        Method        = "",
        Function      = "",
        Constructor   = "",
        Field         = "ﰠ",
        Variable      = "",
        Interface     = "",
        Module        = "",
        Property      = "ﰠ",
        Unit          = "塞",
        Value         = "",
        Enum          = "",
        Keyword       = "",
        Snippet       = "",
        Color         = "",
        File          = "",
        Reference     = "",
        Folder        = "",
        EnumMember    = "",
        Constant      = "",
        Struct        = "פּ",
        Event         = "",
        Operator      = "",
        TypeParameter = ""
    },
    codicons = {
        Copilot       = "",
        Tabnine       = "",
        Text          = "",
        Method        = "",
        Function      = "",
        Constructor   = "",
        Field         = "",
        Variable      = "",
        Class         = "",
        Interface     = "",
        Module        = "",
        Property      = "",
        Unit          = "",
        Value         = "",
        Enum          = "",
        Keyword       = "",
        Snippet       = "",
        Color         = "",
        File          = "",
        Reference     = "",
        Folder        = "",
        EnumMember    = "",
        Constant      = "",
        Struct        = "",
        Event         = "",
        Operator      = "",
        TypeParameter = ""
    }
}

local kind_order = {
    "Copilot", "Text", "Method", "Function", "Constructor", "Field", "Variable",
    "Class", "Interface", "Module", "Property", "Unit", "Value", "Enum",
    "Keyword", "Snippet", "Color", "File", "Reference", "Folder", "EnumMember",
    "Constant", "Struct", "Event", "Operator", "TypeParameter"
}
local kind_len = 25

local function get_symbol(kind)
    local symbol = lspkind.symbol_map[kind]
    if kind == "copilot" then symbol = lspkind.symbol_map["Copilot"] end
    return symbol or ""
end

local modes = {
    ["text"] = function(kind) return kind end,
    ["text_symbol"] = function(kind)
        local symbol = get_symbol(kind)
        return fmt("%s %s", kind, symbol)
    end,
    ["symbol_text"] = function(kind)
        local symbol = get_symbol(kind)
        return fmt("%s %s", symbol, kind)
    end,
    ["symbol"] = function(kind)
        local symbol = get_symbol(kind)
        return fmt("%s", symbol)
    end
}

-- default true
-- deprecated
local function opt_with_text(opts)
    return opts == nil or opts["with_text"] == nil or opts["with_text"]
end

-- default 'symbol'
local function opt_mode(opts)
    local mode = "symbol"
    if opt_with_text(opts) and opts ~= nil and opts["mode"] == nil then
        mode = "symbol_text"
    elseif opts ~= nil and opts["mode"] ~= nil then
        mode = opts["mode"]
    end
    return mode
end

-- default 'default'
local function opt_preset(opts)
    local preset
    if opts == nil or opts["preset"] == nil then
        preset = "default"
    else
        preset = opts["preset"]
    end
    return preset
end

function lspkind.init(opts)
    if opts ~= nil and opts["with_text"] ~= nil then
        vim.api.nvim_command("echoerr 'DEPRECATED replaced by mode option.'")
    end
    local preset = opt_preset(opts)

    local symbol_map = kind_presets[preset]
    lspkind.symbol_map = (opts and opts["symbol_map"] and
        vim.tbl_extend("force", symbol_map,
            opts["symbol_map"])) or symbol_map

    local symbols = {}
    local len = kind_len
    for i = 1, len do
        local name = kind_order[i]
        symbols[i] = lspkind.symbolic(name, opts)
    end

    for k, v in pairs(symbols) do
        require("vim.lsp.protocol").CompletionItemKind[k] = v
    end
end

lspkind.presets = kind_presets
lspkind.symbol_map = kind_presets.codicons

function lspkind.symbolic(kind, opts)
    local mode = opt_mode(opts)
    local formatter = modes[mode]

    -- if someone enters an invalid mode, default to symbol
    if formatter == nil then formatter = modes["symbol"] end

    return formatter(kind)
end

function lspkind.cmp_format(opts)
    if opts == nil then opts = {} end
    if opts.preset or opts.symbol_map then lspkind.init(opts) end

    return function(entry, vim_item)
        if opts.before then vim_item = opts.before(entry, vim_item) end

        vim_item.kind = lspkind.symbolic(vim_item.kind, opts)

        if opts.menu ~= nil then
            vim_item.menu = opts.menu[entry.source.name]
        end

        if opts.maxwidth ~= nil then
            if opts.ellipsis_char == nil then
                vim_item.abbr = string.sub(vim_item.abbr, 1, opts.maxwidth)
            else
                local label = vim_item.abbr
                local truncated_label = vim.fn.strcharpart(label, 0,
                    opts.maxwidth)
                if truncated_label ~= label then
                    vim_item.abbr = truncated_label .. opts.ellipsis_char
                end
            end
        end

        -- Copilot Item Check
        if entry.source.name == "copilot" then
            vim_item.kind = string.format("%s %s", "", "Copilot")
        end

        -- Tabnine Item Check
        if entry.source.name == "cmp_tabnine" then
            vim_item.kind = string.format("%s %s", "", "Tabnine")
        end
        return vim_item
    end
end

return lspkind